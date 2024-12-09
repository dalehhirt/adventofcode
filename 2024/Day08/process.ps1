<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/8
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Process-Part1 {
    [CmdletBinding()]
    param (
      $antennas
      ,$xLowerBound
      , $xUpperBound
      , $yLowerBound
      , $yUpperBound
    )
    
    begin {
      $returnValue = 0
      [System.Collections.ArrayList]$antinodes = @()
    }
    
    process {
      foreach ($antenna in $antennas.Values) {
        foreach ($node in $antenna) {
          foreach ($otherNode in $antenna) {
            if ($node -eq $otherNode) {
              continue
            }
            $dx = $node.X - $otherNode.X
            $dy = $node.Y - $otherNode.Y
            $nx = $otherNode.X - $dx
            $ny = $otherNode.Y - $dy
            if ($nx -lt $xLowerBound -or $nx -gt $xUpperBound -or $ny -lt $yLowerBound -or $ny -gt $yUpperBound) {
              continue
            }
            log "add node: $nx, $ny"
            $antinodes.Add([System.Drawing.Point]::new($nx, $ny)) | out-null
          }
        }
      }
      $returnValue = ($antinodes | Select-Object -Unique | measure).Count
    }
    
    end {
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
      $antennas = @{}
      $xUpperBound = 0
    }
    
    process {
      foreach ($line in $lines) {
        for ($j = 0; $j -lt $line.Length; $j++) {
          $value = $line[$j]
          if ($value -ne ".") {
            if (-not $antennas.ContainsKey($value)) {
              $antennas[$value] = @()
            }
            $antennas[$value] += [System.Drawing.Point]::new($xUpperBound, $j)
          }
        }
        $xUpperBound++
        $yUpperBound = $line.Length
      }
    }

    
    end {
      $returnValue = Process-Part1 -antennas $antennas -xLowerBound 0 -xUpperBound ($xupperbound - 1) -yLowerBound 0 -yUpperBound ($yupperbound - 1)
      return $returnValue
    }
  }

  function Process-Part2 {
    [CmdletBinding()]
    param (
      $antennas
      ,$xLowerBound
      , $xUpperBound
      , $yLowerBound
      , $yUpperBound
    )
    
    begin {
      $returnValue = 0
      [System.Collections.ArrayList]$antinodes = @()
    }
    
    process {
      foreach ($antenna in $antennas.Values) {
        foreach ($node in $antenna) {
          foreach ($otherNode in $antenna) {
            if ($node -eq $otherNode) {
              continue
            }
            $dx = $node.X - $otherNode.X
            $dy = $node.Y - $otherNode.Y
            $nx = $otherNode.X
            $ny = $otherNode.Y
            while (!($nx -lt $xLowerBound -or $nx -gt $xUpperBound -or $ny -lt $yLowerBound -or $ny -gt $yUpperBound)) {
              log "add node: $nx, $ny"
              $antinodes.Add([System.Drawing.Point]::new($nx, $ny)) | out-null
              $nx=$nx-$dx
              $ny=$ny-$dy
            }
          }
        }
      }
      $returnValue = ($antinodes | Select-Object -Unique | measure).Count
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
      $antennas = @{}
      $xUpperBound = 0
    }
    
    process {
      foreach ($line in $lines) {
        for ($j = 0; $j -lt $line.Length; $j++) {
          $value = $line[$j]
          if ($value -ne ".") {
            if (-not $antennas.ContainsKey($value)) {
              $antennas[$value] = @()
            }
            $antennas[$value] += [System.Drawing.Point]::new($xUpperBound, $j)
          }
        }
        $xUpperBound++
        $yUpperBound = $line.Length
      }
    }

    
    end {
      $returnValue = Process-Part2 -antennas $antennas -xLowerBound 0 -xUpperBound ($xupperbound - 1) -yLowerBound 0 -yUpperBound ($yupperbound - 1)
      return $returnValue
    }
  }

  #-----------------
  # Helper functions
  Import-Module $PSScriptRoot\..\..\modules\AdventOfCode.Util -Force -verbose:$false -DisableNameChecking

  log "Beginning processing year 2024 day 08"

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
  log "Ending processing year 2024 day 08"
}
