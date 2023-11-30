<#
.Description
This script runs.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function log() {
    write-host ">>> [$($env:COMPUTERNAME)]" ((Get-Date).ToUniversalTime().ToString('u')) "$args" -ForeGroundColor Green
  }
  
  function log-verbose() {
    write-verbose ">>> [$($env:COMPUTERNAME)] $((Get-Date).ToUniversalTime().ToString('u')) $args"
  }
  
  function log-error() {
    write-error ">>> [$($env:COMPUTERNAME)] $((Get-Date).ToUniversalTime().ToString('u')) $args"
  }

  $InputFile = Resolve-Path (Join-Path $PSScriptRoot "input.txt")
}
process {
  get-content $InputFile

}
end {
}