<#
.Description
This script runs.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {

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
  # Helper functions
  Import-Module $PSScriptRoot\..\..\modules\AdventOfCode.Util -Force -verbose:$false

  #-----------------
  # Global Variables
  $InputFile = Resolve-Path (Join-Path $PSScriptRoot "input.txt")
  log-verbose "Input file path: $InputFile"
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