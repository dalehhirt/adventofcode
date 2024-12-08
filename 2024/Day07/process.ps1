<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/7
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [int]$throttleLimit = 10
)
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

      $processvaluesfuncdef = ${function:Process-Values}.ToString()
      $addToMe = [System.Collections.Concurrent.ConcurrentBag[Int64]]::new()

      log "Started ""$($line)""" $operatorsToTry.Count 
      $operatorsToTry | ForEach-Object -Parallel {
        ${function:Process-Values} = $using:processvaluesfuncdef
        $localAddToMe = $using:addToMe

        $operators = $_
        #log "  operators:" $operators
        $answer = Process-Values -values $using:lineValues -operators ($operators -split ",")

        $localAddToMe.Add($answer)

        if($answer -eq $using:lineTotal) {
          return $answer
        }
      } | Select-Object -First 1 | Out-Null

      log "Finished ""$($line)""" ($operatorsToTry.count -eq $addToMe.Count ? "Tried all $($operatorsToTry.count) permutations" : "Tried $($addToMe.count) of $($operatorsToTry.count) permutations")

      if ($addToMe -contains $lineTotal)  {
        $returnValue = $lineTotal
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

      $processvaluesfuncdef = ${function:Process-Values}.ToString()
      $addToMe = [System.Collections.Concurrent.ConcurrentBag[Int64]]::new()

      log "Started ""$($line)""" $operatorsToTry.Count 
      $operatorsToTry | ForEach-Object -Parallel {
        ${function:Process-Values} = $using:processvaluesfuncdef
        $localAddToMe = $using:addToMe

        $operators = $_
        #log "  operators:" $operators
        $answer = Process-Values -values $using:lineValues -operators ($operators -split ",")

        $localAddToMe.Add($answer)

        if($answer -eq $using:lineTotal) {
          return $answer
        }
      } | Select-Object -First 1 | Out-Null

      log "Finished ""$($line)""" ($operatorsToTry.count -eq $addToMe.Count ? "Tried all $($operatorsToTry.count) permutations" : "Tried $($addToMe.count) of $($operatorsToTry.count) permutations")

      if ($addToMe -contains $lineTotal)  {
        $returnValue = $lineTotal
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
  Import-Module ..\..\modules\AdventOfCode.Util -Force -verbose:$false -DisableNameChecking

  #-----------------
  # Global Variables
  $InputFile1 = Resolve-Path (Join-Path $PSScriptRoot "input1.txt")
  log-verbose "Input file 1 path: $InputFile1"
  $InputFile2 = Resolve-Path (Join-Path $PSScriptRoot "input2.txt")
  log-verbose "Input file 2 path: $InputFile2"

  $processpart1funcdef = ${function:Process-Part1}.ToString()
  $processpart2funcdef = ${function:Process-Part2}.ToString()
  $processvaluesfuncdef = ${function:Process-Values}.ToString()
  $getarrayofoperatorsfuncdef = ${function:Get-ArrayOfOperators}.ToString()
}
process {
  if((get-content $InputFile1) -eq "Placeholder input text file") {
    log "Input 1 data does not exist yet."
  }
  else {
    log "Processing Part 1..."
    $results = get-content $InputFile1 | ForEach-Object -ThrottleLimit $throttleLimit -Parallel  {
      Import-Module ..\..\modules\AdventOfCode.Util -Force -verbose:$false -DisableNameChecking
      ${function:Process-Part1} = $using:processpart1funcdef
      ${function:Process-Values} = $using:processvaluesfuncdef
      ${function:Get-ArrayOfOperators} = $using:getarrayofoperatorsfuncdef
      $global:operatorsPart1 = $using:operatorsPart1

      Process-Part1 -line $_
    }

    $answer = ($results | Measure-Object -sum).Sum

    log "Part 1 Answer:" $answer
  }

  if((get-content $InputFile2) -eq "Placeholder input text file") {
    log "Input 2 data does not exist yet."
  }
  else {
    log "Processing Part 2..."
    $results = get-content $InputFile2 | ForEach-Object -ThrottleLimit $throttleLimit -Parallel {
      Import-Module ..\..\modules\AdventOfCode.Util -Force -verbose:$false -DisableNameChecking
      ${function:Process-Part2} = $using:processpart2funcdef
      ${function:Process-Values} = $using:processvaluesfuncdef
      ${function:Get-ArrayOfOperators} = $using:getarrayofoperatorsfuncdef
      $global:operatorsPart2 = $using:operatorsPart2

      Process-Part2 -line $_
    }

    $answer = ($results | Measure-Object -sum).Sum

    log "Part 2 Answer:" $answer
  }
}
end {
  Pop-Location
}