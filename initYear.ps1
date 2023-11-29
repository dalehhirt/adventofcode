<#
.Description
This script runs.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)]
    [int]
    $Year
)
begin {
  function log() {
    write-host ">>> [$($env:COMPUTERNAME)]" ((Get-Date).ToUniversalTime().ToString('u')) "$args" -ForeGroundColor Green
  }

  function Init-TextFile() {
    param($directory)
    $textFilePath = join-path $directory "Placeholder.txt"
    if (!(Test-Path $textFilePath)) {
        log "Initializing $textFilePath"
        "Placeholder text file" | Out-File -FilePath $textFilePath -Force
    }
  }
}
process {
    $YearPath = (Join-Path $PSScriptRoot $Year)
    if (!(Test-Path $YearPath)) {
        log "Initializing $YearPath"
        mkdir $YearPath
        Init-TextFile -directory $YearPath
    }
    1..25 | ForEach-Object {
        $DayDirectory = Join-Path $YearPath ("Day{0}" -f $_.ToString("00"))

        if (!(Test-Path $DayDirectory)) {
            log "Initializing $DayDirectory"
            mkdir $DayDirectory
            Init-TextFile -directory $DayDirectory
        }
    }
}
end {
}