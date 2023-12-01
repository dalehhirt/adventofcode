<#
.Description
This script runs.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)]
    [int]
    $Year,
    [switch]$Force
)
begin {

  #-----------------
  # Helper functions
  Import-Module $PSScriptRoot\modules\AdventOfCode.Util -Force -verbose:$false

  function Init-TextFile() {
    param($directory, [switch]$Force)
    $textFilePath = join-path $directory "input.txt"
    if (!(Test-Path $textFilePath) -or $Force) {
        log "Initializing $textFilePath"
        "Placeholder input text file" | Out-File -FilePath $textFilePath -Force
    }
  }
}
process {
    $YearPath = (Join-Path $PSScriptRoot $Year)
    if (!(Test-Path $YearPath)) {
      log "Initializing $YearPath"
      mkdir $YearPath
    }
    1..25 | ForEach-Object {
      $DayDirectory = Join-Path $YearPath ("Day{0}" -f $_.ToString("00"))

      if (!(Test-Path $DayDirectory)) {
          log "Initializing $DayDirectory"
          mkdir $DayDirectory
      }
      Init-TextFile -directory $DayDirectory -Force:$Force

      Copy-Item "$PSScriptRoot\process.ps1" $DayDirectory
    }
}
end {
}