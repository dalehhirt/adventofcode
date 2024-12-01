<#
.Description
This script runs.
.LINK
<Replace with link to day problem>
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  class Range {
    [long]$SourceStart
    [long]$DestinationStart
    [long]$NumberRange
  }

  class Map {
    [string] $SourceMap
    [string] $DestinationMap
    [object] $Ranges
    Map() {
      $this.Ranges = @()
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
      log-verbose "Parsing map $sourceMap to $destinationMap"
      foreach ($range in $ranges) {
        $splitLine = $range -split " "
        $numberRange = ([long]$splitLine[2])
        log-verbose "Range:  $range"
        log-verbose "Number spread: $numberRange"
        log-verbose "Source Range: $([long]$splitLine[1]) to $([long]$splitLine[1] + $numberRange - 1)"
        log-verbose "Destination Range: $([long]$splitLine[0]) to $([long]$splitLine[0] + $numberRange - 1)"
        
        $range = [Range]::new()
        $range.SourceStart = [long]$splitLine[1]
        $range.DestinationStart = [long]$splitLine[0]
        $range.NumberRange = $numberRange

        $returnValue[$sourceMap].Ranges += @($range)
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
        $currentValues | ForEach-Object {
          $currentValue = [long]$_
          $foundValue = [long]-1
          foreach ($range in $currentMap.Ranges) {
            if(($currentValue -ge $range.SourceStart) -and ($currentValue -lt ($range.SourceStart + $range.NumberRange))){
              $foundValue = [long]$range.DestinationStart + [long]([long]$currentValue - [long]$range.SourceStart)
            }
          }
          if($foundValue -eq -1) {
            $newValues += @($currentValue)
          }
          else {
            $newValues += @($foundValue)
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
      $seeds = @()
      $maps = @{}
      $currentMapName = ""
      $currentMapLines = @()
    }
    
    process {
      foreach ($line in $lines) {
        if([regex]::match($line, "^seeds:").Success -eq $true){
          $splitSeeds = $line.Replace("seeds:", "") -split " " | Where-Object{$_ -ne ""}
          for ($i = 0; $i -lt $splitSeeds.Count; $i += 2) {
            $seeds += [long]$splitSeeds[$i] .. ([long]$splitSeeds[$i] + [long]$splitSeeds[$i + 1])
          }
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