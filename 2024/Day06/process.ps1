<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/6
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  $directions = @{
    #"up" = 
    "^" = [PSCustomObject]@{
      line = -1
      index = 0
    }
    #"down" = 
    "v" = [PSCustomObject]@{
      line = 1
      index = 0
    }
    #"left" = 
    "<" = [PSCustomObject]@{
      line = 0
      index = -1
    }
    #"right" = 
    ">" = [PSCustomObject]@{
      line = 0
      index = 1
    }
  }

  $changeDirections = @{
    "^" = ">"
    ">" = "v"
    "v" = "<"
    "<" = "^"
  }

  function Process-Part1 {
    [CmdletBinding()]
    param (
      $map,
      $startLine,
      $startIndex,
      $startDirection
    )
    
    begin {
      $returnValue = 0
      $currentDirection = $startDirection
      $currentLine = $startLine
      $currentIndex = $startIndex
      $pathMarker = "X"
      $obstacleMarker = "#"
    }
    
    process {
      while ($true) {
        $nextLine = $currentLine + $directions[$currentDirection].line
        $nextIndex = $currentIndex + $directions[$currentDirection].index
        
        # If current is out of bounds, exit
        if (($nextLine -lt 0) -or 
          ($nextLine -ge $map.Count) -or
          ($nextIndex -lt 0) -or
          ($nextIndex -ge $map[$nextLine].Count)){
            $map[$currentLine][$currentIndex] = $pathMarker
            break
        }

        # If there is something directly in front of you, turn right 90 degrees.
        if ($map[$nextLine][$nextIndex] -eq $obstacleMarker) {
          $currentDirection = $changeDirections[$currentDirection]
        }
        # Take a step forward
        else {
          $map[$currentLine][$currentIndex] = $pathMarker
          $map[$nextLine][$nextIndex] = $currentDirection
          $currentLine += $directions[$currentDirection].line
          $currentIndex += $directions[$currentDirection].index
        }
      }
    }
    
    end {
      $returnValue = ($map.keys | 
                      ForEach-Object {$map[$_]} | 
                      Where-Object {$_ -eq $pathMarker} | 
                      Measure-Object).count
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
      $startingLine = 0
      $startingIndex = 0
      $startingDirection = ""
      $map = @{}
      $lineNumber = 0
    }
    
    process {
      foreach ($line in $lines) {
        $map.Add($lineNumber, [System.Collections.ArrayList]($line -split "" | where {$_ -ne ""})) | out-null
        $directions.keys | ForEach-Object {
          $direction = $_
          for ($j = 0; $j -lt $map[$lineNumber].Count; $j++) {
            if ($map[$lineNumber][$j] -eq $direction) {
              $startingLine = $lineNumber
              $startingIndex = $j
              $startingDirection = $direction
              break
            }
          }
        }

        $lineNumber++
      }
    }
    
    end {
      $returnValue = Process-Part1 -map $map -startLine $startingLine -startIndex $startingIndex -startDirection $startingDirection
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