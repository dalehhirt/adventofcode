<#
.Description
This script runs all scripts.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  #-----------------
  # Helper functions
  Import-Module $PSScriptRoot\..\modules\AdventOfCode.Util -Force -verbose:$false -DisableNameChecking

  #-----------------
  # Global Variables
}
process {
  1..25 | foreach {
    $day = "{0:d2}" -f $_
    $dayScript = "$PSScriptRoot\Day$day\process.ps1"
    log "Running Day $($day):" $dayScript
    Invoke-Expression $dayScript
  }
}
end {
}