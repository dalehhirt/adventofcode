<#
.Description
This script runs.
.LINK
https://adventofcode.com/2022/day/2
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
      $scores = $()
    }
    
    process {
      foreach ($line in $lines) {
        $choices = -split $line

        $leftHand = $leftHandValues[$choices[0]]
        $rightHand = $rightHandValues[$choices[1]]
        
        log-verbose "First Player $leftHand <-> Second Player $rightHand"
        
        $score = $baseValues[$rightHand].Value
        if($leftHand -eq $rightHand) {
          $score += $drawScore
        }
        elseif ($baseValues[$leftHand].Beats -eq $rightHand) {
          $score += $lossScore
        }
        else {
          $score += $winScore
        }
        $scores += $score
      }
    }
    
    end {
      $returnValue = ($scores | Measure-Object -Sum).Sum
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
      $scores = $()
    }
    
    process {
      foreach ($line in $lines) {
        $choices = -split $line

        $leftHand = $leftHandValues[$choices[0]]
        $rightHandPartTwo = $rightHandValuesPartTwo[$choices[1]]
        
        switch ($rightHandPartTwo) {
          "win" { $rightHand = $baseValues.keys | Where-Object {$baseValues[$_].Beats -eq $lefthand} }
          "lose" { $rightHand = $baseValues[$leftHand].Beats }
          "draw" { $rightHand = $leftHand }
        }

        log-verbose "First Player $leftHand <-> Second Player $rightHand"
        $score = $baseValues[$rightHand].Value
        if($leftHand -eq $rightHand) {
          $score += $drawScore
        }
        elseif ($baseValues[$leftHand].Beats -eq $rightHand) {
          $score += $lossScore
        }
        else {
          $score += $winScore
        }
        $scores += $score
      }
    }
    
    end {
      $returnValue = ($scores | Measure-Object -Sum).Sum
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

  $baseValues = @{
    "rock" = [PSCustomObject]@{
      "Value" = 1
      "Beats" = "scissors"
    }
    "paper" = [PSCustomObject]@{
      "Value" = 2
      "Beats" = "rock"
    }
    "scissors" = [PSCustomObject]@{
      "Value" = 3
      "Beats" = "paper"
    }
  }
  $leftHandValues = @{"A"="rock"; "B"="paper"; "C" = "scissors"}
  $rightHandValues = @{"X"="rock"; "Y"="paper"; "Z" = "scissors"}
  $rightHandValuesPartTwo = @{"X"="lose"; "Y"="draw"; "Z" = "win"}
  $winScore = 6
  $lossScore = 0
  $drawScore = 3
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