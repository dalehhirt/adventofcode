<#
.Description
This script runs.
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
  $winScore = 6
  $lossScore = 0
  $drawScore = 3
}
process {
  log "Part 1 Answer:" (get-content $InputFile1 | Get-Part1Answer)

  log "Part 2 Answer:" (get-content $InputFile2 | Get-Part2Answer)
}
end {
}