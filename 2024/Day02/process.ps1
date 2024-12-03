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

        if (($decreaseCount -eq $numDiffs) -or ($increaseCount -eq $numDiffs))
        {
            if ($largeDiffs -eq 0)
            {
                $returnValue++;
            }

            0..($numDiffs - 1) | 
              Where-Object {$levelDiffs[$_] -eq 0} | 
              ForEach-Object {$returnValue = 0}

            continue;
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
      $diffSignCounts =  @(0) * 3 # [0] stores decreasing, [1] stores zero, [2] stores increasing
      # $lastDiffWithSignIndex =  @(0) * 3 # For each sign type, stores the index of the last difference we saw with it
      $levelDiffs =  @(0) * 32; # Stores the pairwise differences of the numbers in the list
      $largeDiffIndexes =  @(0) * 32; # Stores the indexes of any differences that are too large

      $returnValue = 0
      # $part2 = 0
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
          #log "Checking $prev $number"

          $diff = $number - $prev
          $diffSign = [System.Math]::Sign($diff) + 1
          #log $diffSign
          $diffSignCounts[$diffSign]++
          # $lastDiffWithSignIndex[$diffSign] = $numDiffs
          if(($diff -lt -3) -or ($diff -gt 3)){
            $largeDiffIndexes[$largeDiffs++] = $numDiffs
          }

          $levelDiffs[$numDiffs++] = $diff
          $prev = $number
        }

        $decreaseCount = $diffSignCounts[0];
        $increaseCount = $diffSignCounts[2];

        if (($decreaseCount -eq $numDiffs) -or ($increaseCount -eq $numDiffs))
        {
            if ($largeDiffs -eq 0)
            {
              $returnValue++;

              0..($numDiffs - 1) | 
                Where-Object {$levelDiffs[$_] -eq 0} | 
                ForEach-Object {$returnValue = 0}
            }
            elseif ($largeDiffs -eq 1)
            {
                # Only can work if it starts or ends with the large difference
                $largeDiffIndex = $largeDiffIndexes[0];
                if (($largeDiffIndex -eq 0) -or ($largeDiffIndex -eq ($numDiffs - 1))) {
                  $returnValue++;
                }
            }
            continue;
        }

        # Get the index of the single difference going in the wrong direction
        # $expectedSign = 0;
        # $indexToRemove = 0;
        # if ($decreaseCount -eq ($numDiffs - 1))
        # {
        #     $expectedSign = -1;
        #     $indexToRemove = $increaseCount -eq 1 ? $lastDiffWithSignIndex[2] : $lastDiffWithSignIndex[1]; #either increasing or zero
        # }
        # elseif ($increaseCount -eq ($numDiffs - 1))
        # {
        #     $expectedSign = 1;
        #     $indexToRemove = $decreaseCount -eq 1 ? $lastDiffWithSignIndex[0] : $lastDiffWithSignIndex[1]; # either decreasing or zero
        # }
        # else
        # {
        #     # Too many differences in the wrong direction, skip
        #     continue;
        # }

        # Our next goal is to identify which side of the difference should be removed to ensure that the resulting sequence is valid
        # We can easily calculate the new difference are removal by adding together adjacent differences: (a - b) + (b - c) == a - c

        # If there are large differences involved, we may be forced to choose either the left or right side
        # $forcedMergeIndex = -1;
        # if ($largeDiffs -eq 1)
        # {
        #     # Must be either the same as indexToRemove or immediately next to merge
        #     $distance = $largeDiffIndexes[0] - $indexToRemove;
        #     if (($distance -eq -1) -or ($distance -eq 1)) {
        #         $forcedMergeIndex = $indexToRemove + $distance;
        #     }
        #     elseif ($distance -ne 0) {
        #       continue;
        #     }
        # }
        # elseif ($largeDiffs -eq 2)
        # {
        #     # one must be the indexToRemove, the other must be immediately before or after it
        #     $distance1 = $largeDiffIndexes[0] - $indexToRemove;
        #     $distance2 = $largeDiffIndexes[1] - $indexToRemove;
        #     if (($distance1 -eq 0) -and ($distance2 -eq 1)){
        #       $forcedMergeIndex = $indexToRemove + 1;
        #     }
        #     elseif (($distance1 -eq -1) -and ($distance2 -eq 0)){
        #       $forcedMergeIndex = $indexToRemove - 1;
        #     }
        #     else {
        #       continue;
        #     }
        # }
        # elseif ($largeDiffs -gt 2)
        # {
        #     continue;
        # }

        # # Now test the left and right sides to see if the new sequence is valid
        # $diffToRemove = $levelDiffs[$indexToRemove];
        # if ($forcedMergeIndex -ne -1) # handle forced case
        # {
        #   $val = $expectedSign * ($diffToRemove + $levelDiffs[$forcedMergeIndex])
        #   if (($val -gt 0) -and ($val -le 3)) {
        #     $part2++;
        #   }
        # }
        # elseif (($indexToRemove -eq 0) -or 
        #     ($indexToRemove -eq ($numDiffs - 1)) -or
        #     (
        #       (
        #         ($expectedSign * ($diffToRemove + $levelDiffs[$indexToRemove - 1])) -gt 0
        #       ) -and 
        #       (
        #         ($expectedSign * ($diffToRemove + $levelDiffs[$indexToRemove - 1])) -le 3
        #       )
        #     ) -or
        #     (
        #       (
        #         ($expectedSign * (diffToRemove + levelDiffs[indexToRemove + 1])) -gt 0
        #       ) -and 
        #       (
        #         ($expectedSign * (diffToRemove + levelDiffs[indexToRemove + 1])) -le 3
        #       )
        #     )
        # )
        # {
        #     $part2++;
        # }
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