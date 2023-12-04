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
      $returnValue = 0
    }
    
    process {
      # this should always split in two
      $splits = $line -split ":"
      $cardNumber = ([regex]::Match($splits[0], '\d+')).Value

      log-verbose "Processing Card Number" $cardNumber

      # this should always split in two as well
      $cardValues = $splits[1] -split "\|"
      $initialValues = $cardValues[0] -split " "| Where-Object {$_ -ne ""}
      $checkValues = $cardValues[1] -split " " | Where-Object {$_ -ne ""}

      $sameMatchesCount = 0
      $initialValues | ForEach-Object {
        if($checkValues -contains $_){
          $sameMatchesCount++
        }
      }

      if($sameMatchesCount -ge 1) {
        $loopCount = $sameMatchesCount
        $returnValue = 1
        $loopCount--
        while($loopCount -ge 1) {
          $returnValue *= 2
          $loopCount-- 
        }
      }

    }
    
    end {
      return $returnValue
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
      $returnValue = 0
    }
    
    process {
      
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