<#
.Description
This script runs.
.LINK
<Replace with link to day problem>
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
      $regex = "mul\((\d+),(\d+)\)"
    }
    
    process {
      $matchesLine = ([regex]$regex).Matches($line)
      #log "Matches:" $matchesLine.count
      $matchesLine | foreach {
        $matchLine = $_
        $returnValue += ([int]$matchLine.Groups[1].Value * [int]$matchLine.Groups[2].Value)
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
    }
    
    process {
      foreach ($line in $lines) {
        $returnValue += Process-Part1 -line $line
      }
    }
    
    end {
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
      $regex = "mul\((\d+),(\d+)\)"
      $doRegex = "do\(\)"
      $dontRegex = "don\'t\(\)"
      $enableLine = @($null) * $line.Length
    }
    
    process {
      $doMatchesLines = ([regex]$doRegex).Matches($line) | foreach {$_.Index} | Sort-Object
      $dontMatchesLine = ([regex]$dontRegex).Matches($line) | foreach {$_.Index} | Sort-Object
      $locationValue = 1
      for ($i = 0; $i -lt $enableLine.Count; $i++) {
        if($doMatchesLines -contains $i) {
          log "Resetting to do" $i
          $locationValue = 1
        }
        if ($dontMatchesLine -contains $i) {
          log "Resetting to don't" $i
          $locationValue = 0
        }
        $enableLine[$i] = $locationValue
      }

      $matchesLine = ([regex]$regex).Matches($line)
      log "Matches:" $matchesLine.count
      $matchesLine | foreach {
        $matchLine = $_
        if($enableLine[$matchLine.Index] -eq 1) {
          log "adding" $matchLine.Index $matchLine.Groups[0]
          $returnValue += ([int]$matchLine.Groups[1].Value * [int]$matchLine.Groups[2].Value)
        }
        else {
          log "skipping " $matchLine.Index $matchLine.Groups[0]
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
      $returnValue = ""
    }
    
    process {
      foreach ($line in $lines) {
        $returnValue += $line
      }
    }
    
    end {
      return Process-Part2 -line $returnValue
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