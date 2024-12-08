<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/7
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  $operatorsPart1 = @("*", "+")
  $operatorsPart2 = $operatorsPart1 + @("||")

  function Get-ArrayOfOperators(){
    param([int]$count, [string[]]$operatorsToUse)

    [System.Collections.ArrayList]$returnValue = @()

    if ($count -eq 1) {
      $returnValue = $operatorsToUse
    }
    else {
      $oneLessArray = Get-ArrayOfOperators -Count ($count - 1) -operatorsToUse $operatorsToUse
      $operatorsToUse | foreach {
        $operator = $_
        $oneLessArray | ForEach-Object {
          $arrayVal = $_ + "," + $operator
          $returnValue += $arrayVal
        }
      }

    }

    return $returnValue
  }

  function Process-Values {
    [CmdletBinding()]
    param (
      [System.Collections.ArrayList]
      $valuesToUse,
      [System.Collections.ArrayList]
      $operatorsToUse
    )
    
    begin {
      $returnValue = ""
    }
    
    process {
      if($valuesToUse.Count -eq 1) {
        $returnValue = $valuesToUse[0]
      }
      else {
        $val = Process-Values -values $valuesToUse.GetRange(0, $valuesToUse.count - 1)  -operators $operatorsToUse.GetRange(0, $operatorsToUse.Count - 1)
        $operator = $operatorsToUse[$operatorsToUse.Count - 1]

        if ($operator -eq "||") {
          $returnValue = "$val$($valuesToUse[$valuesToUse.count - 1])"
        }
        else {
          $ToTest = "$val$operator$($valuesToUse[$valuesToUse.count - 1])"
        
          $returnValue = Invoke-Expression $ToTest
          # log "To Test:" $ToTest $returnValue
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
      [string]
      $line
    )
    
    begin {
      $returnValue = 0
    }
    
    process {
      $separatorIndex = $line.IndexOf(":") 
      $lineTotal = $line.Substring(0, $separatorIndex)

      $lineValues = $line.Substring($separatorIndex + 1).Trim() -split " "
      $neededOperators = $lineValues.Count - 1

      $operatorsToTry = Get-ArrayOfOperators -count $neededOperators -operatorsToUse $operatorsPart1

      # log "Checking:" 
      # log "  line:" $line
      foreach ($operators in $operatorsToTry) {
        # log "  operators:" $operators
        $answer = Process-Values -values $lineValues -operators ($operators -split ",")
        if($answer -eq $lineTotal) {
          # log "  Valid"
          $returnValue = $answer
          break
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
    }
    
    process {
      foreach ($line in $lines) {
        $returnValue += Process-Part1 $_
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
    }
    
    process {
      $separatorIndex = $line.IndexOf(":") 
      $lineTotal = $line.Substring(0, $separatorIndex)

      $lineValues = $line.Substring($separatorIndex + 1).Trim() -split " "
      $neededOperators = $lineValues.Count - 1

      $operatorsToTry = Get-ArrayOfOperators -count $neededOperators -operatorsToUse $operatorsPart2

      # log "Checking:" 
      # log "  line:" $line
      foreach ($operators in $operatorsToTry) {
        # log "  operators:" $operators
        $answer = Process-Values -values $lineValues -operators ($operators -split ",")
        if($answer -eq $lineTotal) {
          # log "  Valid"
          $returnValue = $answer
          break
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

  Push-Location $PSScriptRoot

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
  Pop-Location
}