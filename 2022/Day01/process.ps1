<#
.Description
This script runs.
.LINK
https://adventofcode.com/2022/day/1
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Get-Part1Answer {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [string[]]
      $lines
    )
    
    begin {
      $returnValue = ""
      $elves = @()
      $calories = 0
    }
    
    process {
      foreach ($line in $lines) {
        log-verbose "Line:" $line
        if($line -eq ""){
          $elves += $calories
          $calories = 0
          return
        }
        $calories += [int]$line
      }
    }
    
    end {
      # This captures the last bit just in case
      $elves += $calories

      $returnValue = ($elves | Sort-Object -Descending | Select-Object -first 1)
      log "Total # of Elves:" $elves.Count
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
      $elves = @()
      $calories = 0
    }
    
    process {
      foreach ($line in $lines) {
        log-verbose "Line:" $line
        if($line -eq ""){
          $elves += $calories
          $calories = 0
          return
        }
        $calories += [int]$line
      }
    }
    
    end {
      # This captures the last bit just in case
      $elves += $calories

      $returnValue = ($elves | Sort-Object -Descending | Select-Object -first 3 | measure-object -Sum).Sum
      log "Total # of Elves:" $elves.Count
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