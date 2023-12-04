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
        $sameValues = @()
        $halfLine = ($line.Length / 2)
        $firstHalf = $line.Substring(0, $halfLine)
        $secondHalf = $line.Substring($halfLine)
        for ($i = 0; $i -lt $halfLine; $i++) {
          for ($j = 0; $j -lt $halfLine; $j++) {
            if($firstHalf[$i] -ceq $secondHalf[$j]) {
              $sameValues += $($firstHalf[$i])
            }
          }
        }
        # Only need to specify type once
        $SameValues = $SameValues | Select-Object -Unique
        $returnValue += $SameValues | Get-CharValue 
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
      }
    }
    
    end {
      return $returnValue
    }
  }

  #-----------------
  # Helper functions
  Import-Module $PSScriptRoot\..\..\modules\AdventOfCode.Util -Force -verbose:$false

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