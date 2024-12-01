<#
.Description
This script runs.
.LINK
https://adventofcode.com/2022/day/3
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Get-CharValue {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline=$true)]
      [string[]]
      $lines
    )
    begin {
      $returnValue = 0
    }
    process{
      foreach ($line in $lines) {
        log-verbose "Char $line"
        if($null -ne ($byteValuesUpperCase.Keys | Where-Object {$_ -ceq $line})) {
          $returnValue += $byteValuesUpperCase[[char]$line]
          log-verbose "Value" $byteValuesUpperCase[[char]$line]
        }
        if($null -ne ($byteValuesLowerCase.Keys | Where-Object {$_ -ceq $line})) {
          $returnValue += $byteValuesLowerCase[[char]$line]
          log-verbose "Value" $byteValuesLowerCase[[char]$line]
        }
      }

    }
    end{
      return $returnValue
    }
  }

  function Check-SameValues() {
    [CmdletBinding()]
    param (
        $FirstString,
        $SecondString
    )
    begin {
      $returnValues = @()
    }
    process{
      for ($i = 0; $i -lt $FirstString.Length; $i++) {
        for ($j = 0; $j -lt $SecondString.Length; $j++) {
          if($FirstString[$i] -ceq $SecondString[$j]) {
            $returnValues += $($FirstString[$i])
          }
        }
      }
    }
    end {
      return $returnValues
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
        $halfLine = ($line.Length / 2)

        $SameValues = Check-SameValues -FirstString $line.Substring(0, $halfLine) -SecondString $line.Substring($halfLine)

        # Only need to specify type once
        $SameValues = $SameValues | Select-Object -Unique
        $returnValue += $SameValues | Get-CharValue 
      }
    }
    
    end {
      return $returnValue
    }
  }

  function Process-Part2 {
    [CmdletBinding()]
    param (
      $lines
    )
    
    begin {
      $returnValue = 0
    }
    
    process {
      $sameValues = Check-SameValues -FirstString $lines[0] -SecondString $lines[1]
      $SameValues = Check-SameValues -FirstString $lines[2] -SecondString (-join $SameValues)

      $SameValues = $SameValues | Select-Object -Unique
      $returnValue = $SameValues | Get-CharValue 

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
      $groupLines = $()
    }
    
    process {
      foreach ($line in $lines) {
        $groupLines += @($line)

        if($groupLines.Count -eq 3) {
          $returnValue += [int](Process-Part2 -lines $groupLines)
          $groupLines = $()
        }
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

  $byteValuesLowerCase = @{}
  $priorityStart = 1
  'a'..'z' | foreach {
    $byteValuesLowerCase[$_] = $priorityStart
    $priorityStart++
  }

  $byteValuesUpperCase = @{}
  $priorityStart = 27
  'A'..'Z' | foreach {
    $byteValuesUpperCase[$_] = $priorityStart
    $priorityStart++
  }
}
process {
  log "Part 1 Answer:" (get-content $InputFile1 | Get-Part1Answer)

  log "Part 2 Answer:" (get-content $InputFile2 | Get-Part2Answer)
}
end {
}