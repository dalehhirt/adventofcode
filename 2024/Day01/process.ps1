<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/1
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Process-Part1 {
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
  function Get-Part1Answer {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [string[]]
      $lines
    )
    
    begin {
      $returnValue = 0
      $list1 = @()
      $list2 = @()
    }
    
    process {
      foreach ($line in $lines) {
        $splitish = -split $line
        $list1 += [int]$splitish[0]
        $list2 += [int]$splitish[1]
      }
    }
    
    end {
      $sortedList1 = $list1 | Sort-Object
      $sortedList2 = $list2 | Sort-Object

      for ($i = 0; $i -lt $sortedList1.Count; $i++) {
        $one = $sortedList1[$i]
        $two = $sortedList2[$i]
        if($one -lt $two) {
          $returnValue += $two - $one
        }
        else {
          $returnValue += $one - $two
        } 
      }
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
      $list1 = @()
      $list2 = @()
    }
    
    process {
      foreach ($line in $lines) {
        $splitish = -split $line
        $list1 += [int]$splitish[0]
        $list2 += [int]$splitish[1]
      }
    }
    
    end {
      $sortedList1 = $list1 | Sort-Object
      $sortedList2 = $list2 | Sort-Object

      for ($i = 0; $i -lt $sortedList1.Count; $i++) {
        $one = $sortedList1[$i]
        $twoList = $sortedList2 | Where-Object {$_ -eq $one}
        $returnValue += $one * $twoList.Count
      }
      return $returnValue
    }
  }

  log "Beginning processing year 2024 day 01"

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
  log "Ending processing year 2024 day 01"
}
