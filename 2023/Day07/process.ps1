<#
.Description
This script runs.
.LINK
<Replace with link to day problem>
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Process-Part1 {
    [CmdletBinding()]
    param (
      $line
    )
    
    begin {
      
    }
    
    process {
      
    }
    
    end {
      
    }
  }
  function Get-Part1Answer {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [string[]]
      $lines
    )
    
    begin {
      $returnValue = 0
    }
    
    process {
      foreach ($line in $lines) {
        $returnValue += Process-Part1 -line $line
      }
    }
    
    end {
      return $returnValue
    }
  }

  function Process-Part2 {
    [CmdletBinding()]
    param (
      $line
    )
    
    begin {
      
    }
    
    process {
      
    }
    
    end {
      
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
      $returnValue = 0
    }
    
    process {
      foreach ($line in $lines) {
        $returnValue += Process-Part2 -line $line
      }
    }
    
    end {
      return $returnValue
    }
  }

  #-----------------
  # Helper functions
  Import-Module $PSScriptRoot\..\..\modules\AdventOfCode.Util -Force -verbose:$false -DisableNameChecking

  #-----------------
  # Global Variables
  $InputFile1 = Resolve-Path (Join-Path $PSScriptRoot "input1.txt")
  log-verbose "Input file 1 path: $InputFile1"
  $InputFile2 = Resolve-Path (Join-Path $PSScriptRoot "input2.txt")
  log-verbose "Input file 2 path: $InputFile2"
}
process {
  log "Part 1 Answer:" (get-content $InputFile1 | Get-Part1Answer)

  log "Part 2 Answer:" (get-content $InputFile2 | Get-Part2Answer)
}
end {
}