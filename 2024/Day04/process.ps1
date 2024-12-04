<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/4
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {

  $points = @{
    "up" = @(-1, 0)
    "down" = @(1, 0)
    "left" = @(0, -1)
    "right" = @(0, 1)
    "up-left" = @(-1, -1)
    "up-right" = @(-1, 1)
    "down-left" = @(1, -1)
    "down-right" = @(1, 1)
  }

  function Search-Word {
    param (
      [string[]]
      $lines,
      [string]
      $word,
      [int]
      $lineIndex,
      [int]
      $charIndex,
      [array]
      $Direction
    )

    begin {
      $lineIndexMove = $Direction[0]
      $charIndexMove = $Direction[1]
      $lineLength = $lines[0].Length
      $returnValue = $true

      $startingLineIndex = $lineIndex
      $startingCharIndex = $charIndex
    }

    process {

      $wordIndex = 1
      $lineIndex += $lineIndexMove
      $charIndex += $charIndexMove

      while ($wordIndex -lt $word.Length) {
        if ( ($lineIndex -lt 0) -or 
          ($lineIndex -ge $lines.Count) -or 
          ($charIndex -lt 0) -or 
          ($charIndex -ge $lineLength)) {
          $returnValue = $false
          break
        }

        if ($lines[$lineIndex][$charIndex] -ne $word[$wordIndex]) {
          $returnValue = $false
          break
        }

        $lineIndex += $lineIndexMove
        $charIndex += $charIndexMove
        $wordIndex++
      }
    }

    end {
      if ($returnValue) {
        return [PSCustomObject]@{
          StartingLineIndex = $startingLineIndex
          StartingCharIndex = $startingCharIndex
          LineIndexMove = $lineIndexMove
          CharIndexMove = $charIndexMove
        }
      }
      else {
        return $null
      }
    }
  }

  function Process-Part1 {
    [CmdletBinding()]
    param (
      [string[]]
      $lines,
      [string]
      $word
    )
    
    begin {
      $returnValue = 0
      $firstLetter = $word[0]
    }
    
    process {
      #foreach ($line in $lines) {
      for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        for ($c = 0; $c -lt $line.Length; $c++) {
          $char = $line[$c]
          if ($char -eq $firstLetter) {
            # There are 8 directions to check for:

            # 1. Up
            if ((Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["up"])) {
                $returnValue++
            }

            # 2. Down
            if ((Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["down"])) {
                $returnValue++
            }

            # 3. Left
            if ((Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["left"])) {
                $returnValue++
            }

            # 4. Right
            if ((Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["right"])) {
                $returnValue++
            }
          
            # 5. Up-Left
            if ((Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["up-left"])) {
                $returnValue++
            }

            # 6. Up-Right
            if ((Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["up-right"])) {
                $returnValue++
            }

            # 7. Down-Left
            if ((Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["down-left"])) {
                $returnValue++
            }

            # 8. Down-Right
            if ((Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["down-right"])) {
                $returnValue++
            }
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
      $Word = "XMAS"
      $copyLines = @()
    }
    
    process {
      foreach ($line in $lines) {
        $copyLines += $line
      }
    }
    
    end {
      $returnValue = Process-Part1 -lines $copyLines -word $Word
      return $returnValue
    }
  }

  function Process-Part2 {
    [CmdletBinding()]
    param (
      [string[]]
      $lines,
      [string]
      $word
    )
    
    begin {
      $returnValue = @()
      $firstLetter = $word[0]      
    }
    
    process {
      #foreach ($line in $lines) {
      for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        for ($c = 0; $c -lt $line.Length; $c++) {
          $char = $line[$c]
          if ($char -eq $firstLetter) {
            # There are 4 directions to check for:
            # 1. Up-Left
            $val = (Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["up-left"])
            if($val) {
              $returnValue += $val
            }

            # 2. Up-Right
            $val = (Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["up-right"])
            if($val) {
              $returnValue += $val
            }

            # 3. Down-Left
            $val = (Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["down-left"])
            if($val) {
              $returnValue += $val
            }

            # 4. Down-Right
            $val = (Search-Word -lines $lines -word $word -lineIndex $i -charIndex $c -Direction $points["down-right"])
            if($val) {
              $returnValue += $val
            }
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
      $copyLines = @()
      $calcAvals = @{}
    }
    
    process {
      foreach ($line in $lines) {
        $copyLines += $line
      }
    }
    
    end {
      $masReturnValue = Process-Part2 -lines $copyLines -word "MAS"
      $masReturnValue | ForEach-Object {
        $key = "$($_.StartingLineIndex + $_.LineIndexMove),$($_.StartingCharIndex + $_.CharIndexMove)"
        if($calcAvals.ContainsKey($key)) {
          $calcAvals[$key]++
        }
        else {
          $calcAvals[$key] = 1
        }
      }
      $returnValue = ($calcAvals.Values |
        ForEach-Object {[int]$_} |
        Where-Object {$_ -ge 2} |
        Measure-Object).Count
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