# Define the names of the GPOs you want to compare
$GPOs = @("GPO1", "GPO2", "GPO3", "GPO4")

# Define the path to store the exported XML files
$ExportPath = "C:\GPO_Exports"

# Create the export directory if it doesn't exist
if (-Not (Test-Path -Path $ExportPath)) {
    New-Item -ItemType Directory -Path $ExportPath
}

# Export each GPO to an XML file
foreach ($GPO in $GPOs) {
    $GPOReportPath = Join-Path -Path $ExportPath -ChildPath "$GPO.xml"
    Get-GPOReport -Name $GPO -ReportType XML -Path $GPOReportPath
    Write-Output "Exported $GPO to $GPOReportPath"
}

# Function to compare two XML files
function Compare-XMLFiles {
    param (
        [string]$File1,
        [string]$File2
    )

    $XML1 = [xml](Get-Content -Path $File1)
    $XML2 = [xml](Get-Content -Path $File2)

    $Difference = Compare-Object -ReferenceObject $XML1 -DifferenceObject $XML2

    if ($Difference) {
        Write-Output "Differences between $File1 and $File2:"
        Write-Output $Difference
    } else {
        Write-Output "No differences found between $File1 and $File2."
    }
}

# Compare the exported XML files
for ($i = 0; $i -lt $GPOs.Count; $i++) {
    for ($j = $i + 1; $j -lt $GPOs.Count; $j++) {
        $File1 = Join-Path -Path $ExportPath -ChildPath "$($GPOs[$i]).xml"
        $File2 = Join-Path -Path $ExportPath -ChildPath "$($GPOs[$j]).xml"
        Compare-XMLFiles -File1 $File1 -File2 $File2
    }
}