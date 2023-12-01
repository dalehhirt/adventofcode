<#
.Description
--- Day 1: Trebuchet?! ---
Something is wrong with global snow production, and you've been selected to take a look. The Elves have even given you a map; on it, they've used stars to mark the top fifty locations that are likely to be having problems.

You've been doing this long enough to know that to restore snow operations, you need to check all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

You try to ask why they can't just use a weather machine ("not powerful enough") and where they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from") when you realize that the Elves are already loading you into a trebuchet ("please hold still, we need to strap you in").

As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.

The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.

For example:

1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.

Consider your entire calibration document. What is the sum of all of the calibration values?#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function log() {
    write-host ">>> [$($env:COMPUTERNAME)]" ((Get-Date).ToUniversalTime().ToString('u')) "$args" -ForeGroundColor Green
  }
  
  function log-verbose() {
    write-verbose ">>> [$($env:COMPUTERNAME)] $((Get-Date).ToUniversalTime().ToString('u')) $args"
  }
  
  function log-error() {
    write-error ">>> [$($env:COMPUTERNAME)] $((Get-Date).ToUniversalTime().ToString('u')) $args"
  }

  function Get-TrueNumberValue() {
    param($value)
    if($numberHash.Contains($value)) {
      return $numberHash[$value]
    }
    return $value
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
      $regex = "\d"
    }
    
    process {
      foreach ($line in $lines) {
        $returnMatches = [regex]::Matches($line, $regex)
        $returnString = $returnMatches[0].Value + $returnMatches[-1].Value
        log-verbose "$line -> $returnString"
        $returnValue += [int]$returnString
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
      $regex = "\d"
    }
    
    process {
      foreach ($line in $lines) {
        $originalLine = $line

        $returnMatches = @()
        while("" -ne $line) {
          if($line[0] -match $regex) {
            $returnMatches += $line[0]
          }
          else {
            foreach ($key in $numberHash.Keys) {
              if($line -match "^$key") {
                $returnMatches += $key
              }
            }
          }
          $line = $line.Substring(1)
        } 
        
        $returnString = (Get-TrueNumberValue $returnMatches[0]) + (Get-TrueNumberValue $returnMatches[-1])
        log-verbose "Matches found:" ($returnMatches -join ",")
        log-verbose "$originalLine -> $returnString"
        $returnValue += [int]$returnString
      }
    }
    
    end {
      return $returnValue
    }
  }

  #-----------------
  # Global Variables
  $InputFile = Resolve-Path (Join-Path $PSScriptRoot "input.txt")
  $numberHash = [ordered]@{"one"="1";
    "two"="2";
    "three"="3";
    "four"="4";
    "five"="5";
    "six"="6";
    "seven"="7";
    "eight"="8";
    "nine"="9"}
}
process {
  $lines = get-content $InputFile

  log "Part 1 Answer:" ($lines | Get-Part1Answer)

  log "Part 2 Answer:" ($lines | Get-Part2Answer)
}
end {
}