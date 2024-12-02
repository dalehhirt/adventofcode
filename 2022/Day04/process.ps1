<#
.Description
This script runs.
.LINK
https://adventofcode.com/2022/day/4
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
      $pairs = $line -split ","
      
      log-verbose "Pair 1" $pairs[0]
      log-verbose "Pair 2" $pairs[1]

      $pair1Split = $pairs[0] -split "-"
      $pair2Split = $pairs[1] -split "-"

      $pair1Ids = $pair1Split[0] .. $pair1Split[1]
      $pair2Ids = $pair2Split[0] .. $pair2Split[1]

      log-verbose "Pair 1 Count" $pair1Ids.Count
      log-verbose "Pair 2 Count" $pair2Ids.Count

      $inPair1 = $pair1Ids | Where-Object {$pair2Ids -contains $_} 
      $inPair2 = $pair2Ids | Where-Object {$pair1Ids -contains $_}

      if(($inPair1.count -eq $pair1Ids.Count) -or ($inPair2.count -eq $pair2ids.Count)) {
        $returnValue = 1
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
      $pairs = $line -split ","
      
      log-verbose "Pair 1" $pairs[0]
      log-verbose "Pair 2" $pairs[1]

      $pair1Split = $pairs[0] -split "-"
      $pair2Split = $pairs[1] -split "-"

      $pair1Ids = $pair1Split[0] .. $pair1Split[1]
      $pair2Ids = $pair2Split[0] .. $pair2Split[1]

      log-verbose "Pair 1 Count" $pair1Ids.Count
      log-verbose "Pair 2 Count" $pair2Ids.Count

      $inPair1 = $pair1Ids | Where-Object {$pair2Ids -contains $_} 
      $inPair2 = $pair2Ids | Where-Object {$pair1Ids -contains $_}

      if(($null -ne $inPair1) -or ($null -ne $inPair2)) {
        $returnValue = 1
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
  if((get-content $InputFile1) -eq "Placeholder input text file") {
    log "Input 1 data does not exist yet."
  }
  else {
    log "Processing Part 1..."
    log "Part 1 Answer:" (get-content $InputFile1 | Get-Part1Answer)
  }

  if((get-content $InputFile2) -eq "Placeholder input text file") {
    log "Input 2 data does not exist yet."
  }
  else {
    log "Processing Part 2..."
    log "Part 2 Answer:" (get-content $InputFile2 | Get-Part2Answer)
  }
}
end {
}