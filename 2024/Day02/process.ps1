<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/2
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Is-Increasing() {
    param ($val1, $val2)

    # if greater than or equal, by default it's false
    $returnValue = $false

    if ($splitLineArray[0] -lt $splitLineArray[1]) {
      $returnValue = $true
    }

    return $returnValue
}
  function Process-Part1 {
    [CmdletBinding()]
    param (
      $line
    )
    
    begin {
      $isIncreasing = $false
      $isSafe = $true
    }
    
    process {
      $splitLineArray = $line.split(" ") | ForEach-Object {[int]$_}
      for ($i = 0; $i -lt $splitLineArray.Count; $i++) {
        if ($i -eq 0) {
          # Do nothing and move on to the next value
          continue
        }
        elseif ($i -eq 1) {
          # Determine if initial direction increasing or decreasing
          $isIncreasing = Is-Increasing -val1 $splitLineArray[0] -val2 $splitLineArray[1]
        }

        $valPrevious = $splitLineArray[$i - 1]
        $valCurrent = $splitLineArray[$i]
        # The levels are either all increasing or all decreasing.
        if($isIncreasing -ne (Is-Increasing -val1 $valPrevious -val2 $valCurrent)) {
          $isSafe = $false
        }

        # Any two adjacent levels differ by at least one and at most three.
        $diffVal = -1
        if($isIncreasing) {
          $diffVal = $valCurrent - $valPrevious
        }
        else {
          $diffVal = $valPrevious - $valCurrent
        }

        if($diffVal -notin (1,2,3)) {
          $isSafe = $false
        }
        
      }
      
    }
    
    end {
      if ($isSafe) {
        return 1
      }
      else {
        return 0
      }
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