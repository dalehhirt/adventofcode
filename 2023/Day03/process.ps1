<#
.Description
This script runs.
.LINK
https://adventofcode.com/2023/day/3
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Match-SymbolsPart1 {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [object[]]
      $Matches,
      $Symbols
    )
    
    begin {
      $SymbolsPositions = @($Symbols.Index)
      $returnValues = $()
    }
    
    process {
      foreach ($match in $Matches) {
        $matchingIndexes = @()
        
        # one before matches for diagonal as well        
        # one after matches for diagonal as well
        $matchingIndexes += ($match.Index - 1)..($match.Index + $match.Length)
        
        $found = $false
        $matchingIndexes | ForEach-Object {
          if($SymbolsPositions -contains $_){
            $found = $true
          }
        }
        if($found) {
          $returnValues += @($match.Value)
        }
      }
    }
    
    end {
      return $returnValues
    }
  }

  function Process-PartNumbersPart1 {
    [CmdletBinding()]
    param (
      $Digits,
      $Symbols
    )
    
    begin {
      $returnValues = $()
      $orderedKeys = $Digits.keys | Sort-Object
    }
    
    process {
      foreach ($key in $orderedKeys) {
        log-verbose "Checking line" $key
        $DigitsMatches = $Digits[$key]
        if($DigitsMatches.Count -eq 0) {
          # skip
          continue
        }

        $BeforeLine = $null
        if($Symbols.ContainsKey($key - 1)) {
          $BeforeLine = $Symbols[$key - 1]
        }

        $CurrentLine = $null
        if($Symbols.ContainsKey($key)) {
          $CurrentLine = $Symbols[$key]
        }

        $AfterLine = $null
        if($Symbols.ContainsKey($key + 1)) {
          $AfterLine = $Symbols[$key + 1]
        }

        if ($null -ne $BeforeLine) {
          $returnValues += @($DigitsMatches | Match-SymbolsPart1 -Symbols $BeforeLine)
        }

        if ($null -ne $CurrentLine) {
          $returnValues += @($DigitsMatches | Match-SymbolsPart1 -Symbols $CurrentLine)
        }

        if ($null -ne $AfterLine) {
          $returnValues += @($DigitsMatches | Match-SymbolsPart1 -Symbols $AfterLine)
        }
      }
    }
    
    end {
      return $returnValues
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
      $returnValue = ""
      $Symbols = @{}
      $notSymbol = "."
      $Digits = @{}
      $reDigits = "\d+"
      $lineNumber = 0
    }
    
    process {
      foreach ($line in $lines) {
        $lineNumber++
        
        log-verbose "Line:" $line
        $digitsMatches = [regex]::Matches($line, $reDigits)
        $Digits.Add($lineNumber, $digitsMatches)

        $symbolMatches = for ($i = 0; $i -lt $line.Length; $i++) {
          log-verbose "Line[i] =" $line[$i]
          if(($line[$i] -notmatch "\d") -and ($line[$i] -ne $notSymbol)) {
            [PSCustomObject]@{
              Value = $line[$i]
              Index = $i
              Length = 1
            }
          }
        }
        $Symbols.Add($lineNumber, $symbolMatches)
      }
    }
    
    end {
      $returnValue = (Process-PartNumbersPart1 -Digits $Digits -Symbols $Symbols | Measure-Object -Sum).Sum
      return $returnValue
    }
  }

function Check-MatchIndexPart2() {
  param([Parameter(ValueFromPipeline=$true)]
  [object[]]
  $Matches,
  $matchIndex)

  begin {
    $returnValues = $()
  }
  
  process {
    foreach ($match in $Matches) {

      $matchingIndexes = @()
      # one before matches for diagonal as well        
      # one after matches for diagonal as well
      $matchingIndexes += ($match.Index - 1)..($match.Index + $match.Length)
    
      if($matchingIndexes -contains $matchIndex){
        $returnValues += @($match)
      }
    }
  }

  end {
    return $returnValues
  }
}

function Match-SymbolsPart2 {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [object[]]
      $Matches,
      $DigitsBefore,
      $DigitsCurrent,
      $DigitsAfter
    )
    
    begin {
      $returnValues = $()
    }
    
    process {
      foreach ($match in $Matches) {
        $DigitsThatCover = @()
        if ($null -ne $DigitsBefore) {
          $DigitsThatCover += @($DigitsBefore | Check-MatchIndexPart2 -matchIndex $match.Index)
        }

        $DigitsThatCover += @($DigitsCurrent | Check-MatchIndexPart2 -matchIndex $match.Index)

        if ($null -ne $DigitsAfter) {
          $DigitsThatCover += @($DigitsAfter | Check-MatchIndexPart2 -matchIndex $match.Index)
        }

        # Filter out nulls
        $DigitsThatCover = ($DigitsThatCover | Where-Object {$null -ne $_})

        # Only do this if we equal 2
        if($DigitsThatCover.Count -eq 2) {
          $returnValues += @([int]$DigitsThatCover[0].Value * [int]$DigitsThatCover[1].Value)
        }
      }
    }
    
    end {
      return $returnValues
    }
  }

  function Process-PartNumbersPart2 {
    [CmdletBinding()]
    param (
      $Digits,
      $Symbols
    )
    
    begin {
      $returnValues = $()
      $orderedKeys = $Symbols.keys | Sort-Object
    }
    
    process {
      foreach ($key in $orderedKeys) {
        log-verbose "Checking line" $key
        $SymbolsMatches = $Symbols[$key]
        if($SymbolsMatches.Count -eq 0) {
          # skip
          continue
        }

        $BeforeLine = $null
        if($Digits.ContainsKey($key - 1)) {
          $BeforeLine = $Digits[$key - 1]
        }

        $CurrentLine = $null
        if($Digits.ContainsKey($key)) {
          $CurrentLine = $Digits[$key]
        }

        $AfterLine = $null
        if($Digits.ContainsKey($key + 1)) {
          $AfterLine = $Digits[$key + 1]
        }

        $returnValues += @($SymbolsMatches | Match-SymbolsPart2 -DigitsBefore $BeforeLine -DigitsCurrent $CurrentLine -DigitsAfter $AfterLine)
      }
    }
    
    end {
      return $returnValues
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
      $Symbols = @{}
      $Digits = @{}
      $reDigits = "\d+"
      $lineNumber = 0
    }
    
    process {
      foreach ($line in $lines) {
        $lineNumber++
        
        log-verbose "Line:" $line
        $digitsMatches = [regex]::Matches($line, $reDigits)
        $Digits.Add($lineNumber, $digitsMatches)

        $symbolMatches = for ($i = 0; $i -lt $line.Length; $i++) {
          log-verbose "Line[i] =" $line[$i]
          if($line[$i] -eq "*") {
            [PSCustomObject]@{
              Value = $line[$i]
              Index = $i
              Length = 1
            }
          }
        }
        $Symbols.Add($lineNumber, $symbolMatches)
      }
    }
    
    end {
      $returnValue = (Process-PartNumbersPart2 -Digits $Digits -Symbols $Symbols | Measure-Object -Sum).Sum
      return $returnValue
    }
  }

  #-----------------
  # Helper functions
  Import-Module $PSScriptRoot\..\..\modules\AdventOfCode.Util -Force -verbose:$false

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