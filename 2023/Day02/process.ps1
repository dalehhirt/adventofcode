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
      $regex = "(\d+):"
      $games = @()
    }
    
    process {
      foreach ($line in $lines) {
        $minRed = 0
        $minBlue = 0
        $minGreen = 0

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
                if($minGreen -lt [int]$values[0]){
                  $minGreen = [int]$values[0]
                }
              }
              "red" {
                if($minRed -lt [int]$values[0]){
                  $minRed = [int]$values[0]
                }
              }
              "blue" {
                if($minBlue -lt [int]$values[0]){
                  $minBlue = [int]$values[0]
                }
              }
              Default {}
            }
          }
        }
        # Sum here
        $games += ($minRed * $minBlue * $minGreen)
      }

      $returnValue = ($games | Measure-Object -sum).sum
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
  log-verbose "Input file 1 path: $InputFile2"
}
process {
  log "Part 1 Answer:" (get-content $InputFile1 | Get-Part1Answer)

  log "Part 2 Answer:" (get-content $InputFile2 | Get-Part2Answer)
}
end {
}