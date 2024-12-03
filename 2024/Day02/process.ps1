<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/2
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
      $diffSignCounts =  @(0) * 3 # [0] stores decreasing, [1] stores zero, [2] stores increasing
      $levelDiffs =  @(0) * 32; # Stores the pairwise differences of the numbers in the list
      $largeDiffIndexes =  @(0) * 32; # Stores the indexes of any differences that are too large

      $returnValue = 0
    }
    
    process {
      $splitLineArray = [System.Collections.ArrayList]($line.split(" ") | ForEach-Object {[int]$_})

      $i = 0
      while($i -lt $splitLineArray.Count) {
        $numDiffs = 0;
        $largeDiffs = 0;

        $prev = $splitLineArray[$i++]

        while($i -lt $splitLineArray.Count) {
          $number = $splitLineArray[$i++]

          $diff = $number - $prev
          $diffSign = [System.Math]::Sign($diff) + 1
          $diffSignCounts[$diffSign]++
          if(($diff -lt -3) -or ($diff -gt 3)){
            $largeDiffIndexes[$largeDiffs++] = $numDiffs
          }

          $levelDiffs[$numDiffs++] = $diff
          $prev = $number
        }

        $decreaseCount = $diffSignCounts[0];
        $increaseCount = $diffSignCounts[2];
        $levelCount = $diffSignCounts[1]

        if (($decreaseCount -eq $numDiffs) -or ($increaseCount -eq $numDiffs))
        {
          if (($largeDiffs -eq 0) -and ($levelCount -eq 0))
          {
              $returnValue = 1;
          }
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
      $splitLineArray = [System.Collections.ArrayList]($line.split(" ") | ForEach-Object {[int]$_})
      
      $returnValue = Process-Part1 -line $line
      if(!$returnValue) {
        for ($i = 0; $i -lt $splitLineArray.Count; $i++) {
          $splitLineArrayCopy = new-object System.Collections.ArrayList
          $splitLineArrayCopy.AddRange($splitLineArray)
          $splitLineArrayCopy.RemoveAt($i)

          if(Process-Part1 -line ($splitLineArrayCopy -join " ")) {
            $returnValue = 1
            break
          }
        }
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