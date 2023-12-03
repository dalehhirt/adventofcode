<#
.Description
This script runs.
.LINK
https://adventofcode.com/2023/day/3
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Match-Symbols {
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

  function Process-PartNumbers {
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
          $returnValues += @($DigitsMatches | Match-Symbols -Symbols $BeforeLine)
        }

        if ($null -ne $CurrentLine) {
          $returnValues += @($DigitsMatches | Match-Symbols -Symbols $CurrentLine)
        }

        if ($null -ne $AfterLine) {
          $returnValues += @($DigitsMatches | Match-Symbols -Symbols $AfterLine)
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
      $returnValue = (Process-PartNumbers -Digits $Digits -Symbols $Symbols | Measure-Object -Sum).Sum
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