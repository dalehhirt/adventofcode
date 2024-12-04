<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/4
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {

  function Match-Value {
    [CmdletBinding()]
    param (
      [string[]]
      $lines,
      [int]
      $line,
      [int]
      $index,
      [string]
      $value
    )
    
    begin {
      $returnValue = $false
    }
    
    process {
      if ($lines[$line - 1][$index] -eq $value) {
        $returnValue = $true
      }
    }
    
    end {
      return $returnValue
    }
  }

  function Process-Part1 {
    [CmdletBinding()]
    param (
      [string[]]
      $lines,
      [object[]]
      $matchLines
    )
    
    begin {
      $returnValue = 0
      $totalLength = 4
      $minIndex = $totalLength - 1
      $maxIndex = $lines[0].Length - $totalLength -1
      $minLine = $totalLength
      $maxLine = $lines.Count - $totalLength
    }
    
    process {
      foreach ($matchLine in $matchLines) {
        # There are 8 directions to check for:

        # 1. Up
        if ($matchLine.Line -ge $minLine) {
          <# Action to perform if the condition is true #>
          if(Match-Value -lines $lines -line ($matchLine.Line - 1) -index $matchLine.Index -value "M") {
            if(Match-Value -lines $lines -line ($matchLine.Line - 2) -index $matchLine.Index -value "A") {
              if(Match-Value -lines $lines -line ($matchLine.Line - 3) -index $matchLine.Index -value "S") {
                  $returnValue++
                  log-verbose "Match found at line $($matchLine.Line) and index $($matchLine.Index) up"
              }
            }
          }
        }
        # 2. Down
        if ($matchLine.Line -le $maxLine) {
          if(Match-Value -lines $lines -line ($matchLine.Line + 1) -index $matchLine.Index -value "M") {
            if(Match-Value -lines $lines -line ($matchLine.Line + 2) -index $matchLine.Index -value "A") {
              if(Match-Value -lines $lines -line ($matchLine.Line + 3) -index $matchLine.Index -value "S") {
                  $returnValue++
                  log-verbose "Match found at line $($matchLine.Line) and index $($matchLine.Index) down"
              }
            }
          }
        }
        # 3. Left
        if ($matchLine.index -ge $minIndex) {
          if(Match-Value -lines $lines -line ($matchLine.Line) -index ($matchLine.Index - 1) -value "M") {
            if(Match-Value -lines $lines -line ($matchLine.Line) -index ($matchLine.Index - 2) -value "A") {
              if(Match-Value -lines $lines -line ($matchLine.Line) -index ($matchLine.Index - 3) -value "S") {
                  $returnValue++
                  log-verbose "Match found at line $($matchLine.Line) and index $($matchLine.Index) left"
              }
            }
          }
        }
        # 4. Right
        if ($matchLine.index -le $maxIndex) {
          if(Match-Value -lines $lines -line ($matchLine.Line) -index ($matchLine.Index + 1) -value "M") {
            if(Match-Value -lines $lines -line ($matchLine.Line) -index ($matchLine.Index + 2) -value "A") {
              if(Match-Value -lines $lines -line ($matchLine.Line) -index ($matchLine.Index + 3) -value "S") {
                  $returnValue++
                  log-verbose "Match found at line $($matchLine.Line) and index $($matchLine.Index) right"
              }
            }
          }
        }
        # 5. Up-Left
        if ($matchLine.line -ge $minLine -and $matchLine.index -ge $minIndex) {
          if(Match-Value -lines $lines -line ($matchLine.Line - 1) -index ($matchLine.Index - 1) -value "M") {
            if(Match-Value -lines $lines -line ($matchLine.Line - 2) -index ($matchLine.Index - 2) -value "A") {
              if(Match-Value -lines $lines -line ($matchLine.Line - 3) -index ($matchLine.Index - 3) -value "S") {
                  $returnValue++
                  log-verbose "Match found at line $($matchLine.Line) and index $($matchLine.Index) up-left"
              }
            }
          }
        }
        # 6. Up-Right
        if ($matchLine.line -ge $minLine -and $matchLine.index -le $maxIndex) {
          if(Match-Value -lines $lines -line ($matchLine.Line - 1) -index ($matchLine.Index + 1) -value "M") {
            if(Match-Value -lines $lines -line ($matchLine.Line - 2) -index ($matchLine.Index + 2) -value "A") {
              if(Match-Value -lines $lines -line ($matchLine.Line - 3) -index ($matchLine.Index + 3) -value "S") {
                  $returnValue++
                  log-verbose "Match found at line $($matchLine.Line) and index $($matchLine.Index) up-right"
              }
            }
          }
        }
        # 7. Down-Left
        if ($matchLine.line -le $maxLine -and $matchLine.index -ge $minIndex) {
          if(Match-Value -lines $lines -line ($matchLine.Line + 1) -index ($matchLine.Index - 1) -value "M") {
            if(Match-Value -lines $lines -line ($matchLine.Line + 2) -index ($matchLine.Index - 2) -value "A") {
              if(Match-Value -lines $lines -line ($matchLine.Line + 3) -index ($matchLine.Index - 3) -value "S") {
                  $returnValue++
                  log-verbose "Match found at line $($matchLine.Line) and index $($matchLine.Index) down-left"
              }
            }
          }
        }

        # 8. Down-Right
        if ($matchLine.line -le $maxLine -and $matchLine.index -le $maxIndex) {
          if(Match-Value -lines $lines -line ($matchLine.Line + 1) -index ($matchLine.Index + 1) -value "M") {
            if(Match-Value -lines $lines -line ($matchLine.Line + 2) -index ($matchLine.Index + 2) -value "A") {
              if(Match-Value -lines $lines -line ($matchLine.Line + 3) -index ($matchLine.Index + 3) -value "S") {
                  $returnValue++
                  log-verbose "Match found at line $($matchLine.Line) and index $($matchLine.Index) down-right"
              }
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
      $beginningSymbol = "X"
      $lineNumber = 0
      $lineLength = 0
      $copyLines = @()
      $lineMatches = @()
    }
    
    process {
      $lineMatches += foreach ($line in $lines) {
        $lineNumber++
        
        if (1 -eq $lineNumber) {
          $lineLength = $line.Length
        }
        else {
          if ($lineLength -ne $line.Length) {
            throw "Line $($lineNumber) has a different length than the first line ($lineLength)." 
          }
        }

        $copyLines += $line
        
        log-verbose "Line $($lineNumber):" $line
        $matchesLine = ([regex]$beginningSymbol).Matches($line)
        #log "Matches:" $matchesLine.count
        $matchesLine | foreach {
          $matchLine = $_
          [PSCustomObject]@{
            Index = $matchLine.Index
            Line = $lineNumber
          } 
        }
      }
    }
    
    end {
      $lineMatches | foreach {log-verbose $_.Line $_.Index}
      log "Found $($lineMatches.Count) matches."
      $returnValue = Process-Part1 -lines $copyLines -matchLines $lineMatches
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