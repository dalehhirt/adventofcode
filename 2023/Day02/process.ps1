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
      $regex = "(\d+):"
      # 12 red cubes, 13 green cubes, and 14 blue cubes
      $totalRed = 12
      $totalGreen = 13
      $totalBlue = 14
      $games = @()
    }
    
    process {
      foreach ($line in $lines) {
        $validGame = $true
        $game = [regex]::Matches($line, $regex)[0]
        log-verbose "Game Number" $game.Groups[1]
        $handfuls = ($line -split ":")[1] -split ";"
        foreach ($handful in $handfuls) {
          #log-verbose "Handful:" $handful
          $cubes = $handful -split ","
          foreach ($cube in $cubes) {
            #log-verbose "Cube:" $cube
            $values = -split $cube
            #log-verbose $values[1] $values[0]
            switch ($values[1]) {
              "green" {
                if($totalGreen -lt [int]$values[0]){
                  log-verbose "Green: Expected:" $totalBlue "Actual:" $values[0]
                  $validGame = $false
                }
              }
              "red" {
                if($totalRed -lt [int]$values[0]){
                  log-verbose "Red: Expected:" $totalBlue "Actual:" $values[0]
                  $validGame = $false
                }
              }
              "blue" {
                if($totalBlue -lt [int]$values[0]){
                  log-verbose "Blue: Expected:" $totalBlue "Actual:" $values[0]
                  $validGame = $false
                }
              }
              Default {}
            }
          }
        }
        if($validGame) {
          $games += $game.Groups[1]
        }
      }
    }
    
    end {
      $returnValue =  ($games.value | measure-object -sum).Sum
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
  $InputFile = Resolve-Path (Join-Path $PSScriptRoot "input.txt")
  log-verbose "Input file path: $InputFile"
}
process {
  $lines = get-content $InputFile

  log "Part 1 Answer:" ($lines | Get-Part1Answer)

  log "Part 2 Answer:" ($lines | Get-Part2Answer)
}
end {
}