<#
.Description
This script runs.
.LINK
<Replace with link to day problem>
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Compact-MapPart2 () {
    param(
      [System.Collections.ArrayList]
      $map,
      [int]
      $maxFileId
    )

    begin {
      [System.Collections.ArrayList]$newMap = $map.Clone()
      $newMap.Capacity = $map.Count
      $space = "."
    }

    process {
      #log "Before:" ($newMap -join "")
      for ($i = $maxFileId; $i -ge 0; $i--) {
        #log "Processing file $i"
        $fileStartIndex = $newMap.IndexOf($i)
        $fileEndIndex = $newMap.LastIndexOf($i)
        $fileLength = $fileEndIndex - $fileStartIndex + 1

        $spaceLength = 0
        $spaceStartIndex = 0
        for ($j = 0; $j -lt $newMap.Count; $j++) {
          
          if($newMap[$j] -eq $space) {
            if($spaceLength -eq 0) {
              $spaceStartIndex = $j
            }
            $spaceLength++
          }
          else {
            if($spaceLength -ge $fileLength -and $spaceStartIndex -lt $fileStartIndex) {
              for($k = 0; $k -lt $fileLength; $k++) {
                $newMap[$spaceStartIndex + $k] = $newMap[$fileStartIndex + $k]
                $newMap[$fileStartIndex + $k] = $space
              }
            }

            $spaceLength = 0
          }
        }

        #log ($newMap -join "")
      }
    }

    end {
      return $newMap
    }
  }

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
      $mappingValues
    )
    
    begin {
      $returnValue = 0
      $spaces = @{}
      $fileIds = @{}
      [System.Collections.ArrayList]$map = @()
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
            $map.Add(".") | out-null
          }
          else {
            $mapNumberString = "$mapNumber"
            for ($i = 0; $i -lt $mapNumberString.Length; $i++) {
              $map.add($mapNumberString[$i])
            }
          }
        }

        if ($isSpace) {
          $mapNumber++
        }

        $isSpace = !$isSpace
      }

      $map = Compact-MapPart2 -map $map -maxFileId $mapNumber
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

  function Get-Part2Answer {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [string[]]
      $lines
    )
    
    begin {
      $returnValue = 0
      [System.Collections.ArrayList]$mappingValues = @()
    }
    
    process {
      foreach ($line in $lines) {
        $mappingValues = $line -split "" | where {$_ -ne ""}
      }
    }
    
    end {
      $returnValue = Process-Part2 -mappingValues $mappingValues
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