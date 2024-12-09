<#
.Description
This script runs.
.LINK
<Replace with link to day problem>
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Compact-Map () {
    param(
      [System.Collections.ArrayList]
      $map
    )

    begin {
      [System.Collections.ArrayList]$newMap = $map.Clone()
      $newMap.Capacity = $map.Count
      $space = "."
    }

    process {
      for ($i = $newMap.Count - 1; $i -ge 0; $i--) {
        $firstSpace = $newMap.IndexOf($space)
        if($newMap[$i] -ne $space -and $i -gt $firstSpace) {
          $newMap[$firstSpace] = $newMap[$i]
          $newMap[$i] = $space
        }
      }
    }

    end {
      return $newMap
    }
  }
  function Process-Part1 {
    [CmdletBinding()]
    param (
      $map,
      $mappingValues
    )
    
    begin {
      $returnValue = 0
    }
    
    process {
      $isSpace=$false
      $mapIndex = 0
      $mapNumber = 0

      foreach ($value in $mappingValues) {
        if($value -eq 0) {
          if($isSpace) {
            $mapNumber++
          }

          $isSpace = !$isSpace
          continue
        }

        1..$value | foreach {
          if ($isSpace) {
            $map[$mapIndex] = "."
          }
          else {
            $map[$mapIndex] = $mapNumber
          }
          $mapIndex++
        }

        if ($isSpace) {
          $mapNumber++
        }

        $isSpace = !$isSpace
      }

      $map = Compact-Map -map $map
      for($i = 0; $i -lt $map.Count; $i++) {
        if($map[$i] -ne ".") {
          $returnValue += ($i * $map[$i])
        }
      }
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
      [System.Collections.ArrayList]$map = @()
      [System.Collections.ArrayList]$mappingValues = @()
    }
    
    process {
      foreach ($line in $lines) {
        $mappingValues = $line -split "" | where {$_ -ne ""}
        $totalLine = [int64]($mappingValues | measure -sum | select -expand sum)
        1..$totalLine | foreach {$map.Add(".") | out-null}
        # $returnValue += Process-Part1 -line $line
      }
    }
    
    end {
      $returnValue = Process-Part1 -map $map -mappingValues $mappingValues
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