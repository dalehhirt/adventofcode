<#
.Description
This script runs.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Get-Part1Answer {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [string[]]
      $lines
    )
    
    begin {
      $returnValue = ""
    }
    
    process {
      foreach ($line in $lines) {
      }
    }
    
    end {
      return $returnValue
    }
  }

  function Get-Part2Answer {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [string[]]
      $lines
    )
    
    begin {
      $returnValue = ""
    }
    
    process {
      foreach ($line in $lines) {
      }
    }
    
    end {
      return $returnValue
    }
  }

  #-----------------
  # Helper functions
  Import-Module $PSScriptRoot\..\..\modules\AdventOfCode.Util -Force -verbose:$false

  #-----------------
  # Global Variables
  $InputFile = Resolve-Path (Join-Path $PSScriptRoot "input.txt")
  log-verbose "Input file path: $InputFile"
}
process {
  $lines = get-content $InputFile

  log "Part 1 Answer:" ($lines | Get-Part1Answer)

  log "Part 2 Answer:" ($lines | Get-Part2Answer)
}
end {
}