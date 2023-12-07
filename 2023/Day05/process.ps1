<#
.Description
This script runs.
.LINK
<Replace with link to day problem>
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  class Map {
    [string] $SourceMap
    [string] $DestinationMap
    [object] $SinglePoints
    Map() {
      $this.SinglePoints = @{}
    }
  }

  function Add-KeyValuePair {
    [CmdletBinding()]
    param (
      $hashTable,
      $key,
      $value
    )
    
    begin {
      
    }
    
    process {
      $found = $hashTable.Keys | Where-Object {$_ -eq $key}
      if($null -eq $found) {
        $hashTable.Add($key, $value)
      }
      else {
        $hashTable[$key] = $value
      }
    }
    
    end {
      
    }
  }
  function Create-Map {
    param (
      [string]$MapName,
      [string[]]$ranges
    )
    begin {
      $mappings = $MapName -split "-to-"
      $sourceMap = $mappings[0]
      $destinationMap = $mappings[1]
      
      $returnValue = @{$sourceMap = [Map]::new()}

      $returnValue[$sourceMap].SourceMap = $sourceMap
      $returnValue[$sourceMap].DestinationMap = $destinationMap
    }
    
    process {
      log-verbose "Parsing for map $sourceMap to $destinationMap"
      foreach ($range in $ranges) {
        $splitLine = $range -split " "
        $numberRange = ([long]$splitLine[2])
        for ($i = 0; $i -lt $numberRange; $i++) {
          Add-KeyValuePair -hashTable $returnValue[$sourceMap].SinglePoints -key (([long]$splitLine[1]) + $i) -value (([long]$splitLine[0]) + $i)
        }
      }
    }
    
    end {
      return $returnValue
    }
  }

  function Process-Part1 {
    [CmdletBinding()]
    param (
      $seeds,
      $maps
    )
    
    begin {
      $returnValue = 0
      $currentSet = "seed"
      $currentValues = $seeds
    }
    
    process {
      do {
        log-verbose "Checking against $currentSet map"
        $currentMap = $maps[$currentSet]
        $newValues = @()
        $currentValues | foreach {
          $currentValue = $_
          if($null -ne ($currentMap.SinglePoints.Keys | Where-Object {$_ -eq $currentValue})) {
            $newValues += @($currentMap.SinglePoints[[long]$currentValue])
          }
          else {
            $newValues += @($currentValue)
          }
        }
        $currentValues = $newValues

        log-verbose "Moving to $($currentMap.DestinationMap) map"
        $currentSet = $currentMap.DestinationMap
      } until (
        $currentSet -eq "location"
      )
      
      $returnValue = $currentValues | Sort-Object | Select-Object -first 1
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
      $seeds = @()
      $maps = @{}
      $currentMapName = ""
      $currentMapLines = @()
    }
    
    process {
      foreach ($line in $lines) {
        if([regex]::match($line, "^seeds:").Success -eq $true){
          $seeds += $line.Replace("seeds:", "") -split " " | Where-Object{$_ -ne ""}
        }
        elseif([regex]::match($line, "^.*\smap:").Success -eq $true){
          if($currentMapName -ne "") {
            log-verbose "Creating map for $currentMapName"
            $maps += Create-Map -MapName $currentMapName -ranges $currentMapLines
            $currentMapLines = @()
          }
          $currentMapName = $line.Replace(" map:", "")
        }
        elseif ($line -ne "") {
          $currentMapLines += $line
        }
        #$returnValue += Process-Part1 -line $line
      }
    }
    
    end {
      # one last time to account for last set of values
      log-verbose "Creating map for $currentMapName"
      $maps += Create-Map -MapName $currentMapName -ranges $currentMapLines

      $returnValue = Process-Part1 -seeds $seeds -maps $maps
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
  log "Part 1 Answer:" (get-content $InputFile1 | Get-Part1Answer)

  log "Part 2 Answer:" (get-content $InputFile2 | Get-Part2Answer)
}
end {
}