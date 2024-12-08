<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/7
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  [int]$throttleLimit = 10
)
begin {
  class Day7TreeNode {
    [System.Collections.ArrayList]$pair
    [Day7TreeNode]$sum
    [Day7TreeNode]$prod
    [Day7TreeNode]$concat


    Day7TreeNode( [System.Collections.ArrayList]$pair) {
      $this.pair = $pair
      $this.sum = $null
      $this.prod = $null
      $this.concat = $null
    }

    [void] AddChild([int64]$number) {
      $this.sum = [Day7TreeNode]::new( [System.Collections.ArrayList]@( ([int64]$this.pair[0] + [int64]$this.pair[1]), $number) )
      $this.prod = [Day7TreeNode]::new([System.Collections.ArrayList]@(([int64]$this.pair[0] * [int64]$this.pair[1]), $number))
      $this.concat = [Day7TreeNode]::new([System.Collections.ArrayList]@([int64]("$($this.pair[0])$($this.pair[1])"), $number))
    }
  }

  function add-nodes() {
    param ([Day7TreeNode]$node, [int64]$number)
    if ($null -eq $node.sum) {
      # no children
      #log "Child: $number"
      $node.AddChild($number)
      return
    }
    add-nodes -node $node.sum -number $number
    add-nodes -node $node.prod -number $number
    add-nodes -node $node.concat -number $number
  }

  function get_totals([Day7TreeNode]$node, [bool]$skipConcat = $true) {
    [System.Collections.ArrayList]$total_list = @()
    if ($null -eq $node.sum) {
        $total_list.Add([int64]$node.pair[0] + [int64]$node.pair[1])
        $total_list.Add([int64]$node.pair[0] * [int64]$node.pair[1])
        if(!$skipConcat) {
          $total_list.Add([int64]"$($node.pair[0])$($node.pair[1])")
        }
    }
    else {
      $total_list.AddRange((get_totals -node $node.sum -skipConcat $skipConcat))
      $total_list.AddRange((get_totals -node $node.prod -skipConcat $skipConcat))
      if(!$skipConcat) {
        $total_list.AddRange((get_totals -node $node.concat -skipConcat $skipConcat))
      }
    }
    return $total_list
  }


  function Process-Part1 {
    [CmdletBinding()]
    param (
      [string]
      $line,
      $throttleLimit
    )
    
    begin {
      $returnValue = 0
    }
    
    process {
      $separatorIndex = $line.IndexOf(":") 
      $lineTotal = [int64]$line.Substring(0, $separatorIndex)

      [System.Collections.ArrayList]$lineValues = $line.Substring($separatorIndex + 1).Trim() -split " "
      if ($lineValues.Count -eq 2) {
        if ([Int64]([Int64]$lineValues[0] + [Int64]$lineValues[1]) -eq $lineTotal) {
          $returnValue = $lineTotal
        }
        elseif ([Int64]([Int64]$lineValues[0] * [Int64]$lineValues[1]) -eq $lineTotal) {
          $returnValue = $lineTotal
        }
        # elseif ([int64]("$($lineValues[0])$($lineValues[1])") -eq $lineTotal) {
        #   log "Valid: $lineTotal"
        #   $returnValue = $lineTotal
        # }
      }
      else {
        $root = [Day7TreeNode]::new([System.Collections.ArrayList]$lineValues.GetRange(0, 2))
        $otherValues = [System.Collections.ArrayList]$lineValues.GetRange(2, $lineValues.Count - 2)
        foreach ($number in $otherValues) {
          add-nodes -node $root -number $number
        }

        $total_list = get_totals $root
        if($total_list -contains $lineTotal) {
          $returnValue = $lineTotal
        }
      }
    }
    
    end {
      if ($returnValue) {
        #log "Valid: $returnValue"
      }
      return $returnValue
    }
  }

  function Get-Part1Answer {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline = $true)]
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
      [string]
      $line,
      $throttleLimit
    )
    
    begin {
      $returnValue = 0
    }
    
    process {
      $separatorIndex = $line.IndexOf(":") 
      $lineTotal = [int64]$line.Substring(0, $separatorIndex)

      [System.Collections.ArrayList]$lineValues = $line.Substring($separatorIndex + 1).Trim() -split " "
      if ($lineValues.Count -eq 2) {
        if ([Int64]([Int64]$lineValues[0] + [Int64]$lineValues[1]) -eq $lineTotal) {
          $returnValue = $lineTotal
        }
        elseif ([Int64]([Int64]$lineValues[0] * [Int64]$lineValues[1]) -eq $lineTotal) {
          $returnValue = $lineTotal
        }
        elseif ([int64]("$($lineValues[0])$($lineValues[1])") -eq $lineTotal) {
          $returnValue = $lineTotal
        }
      }
      else {
        $root = [Day7TreeNode]::new([System.Collections.ArrayList]$lineValues.GetRange(0, 2))
        $otherValues = [System.Collections.ArrayList]$lineValues.GetRange(2, $lineValues.Count - 2)
        foreach ($number in $otherValues) {
          add-nodes -node $root -number $number
        }

        $total_list = get_totals -node $root -skipConcat $false
        if($total_list -contains $lineTotal) {
          $returnValue = $lineTotal
        }
      }
    }
    
    end {
      if ($returnValue) {
        #log "Valid: $returnValue"
      }
      return $returnValue
    }
  }

  function Get-Part2Answer {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline = $true)]
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

  log "Beginning processing year 2024 day 07"

  #-----------------
  # Helper functions
  Import-Module ..\..\modules\AdventOfCode.Util -Force -DisableNameChecking

  #-----------------
  # Global Variables
  $InputFile1 = Resolve-Path (Join-Path $PSScriptRoot "input1.txt")
  log-verbose "Input file 1 path: $InputFile1"
  $InputFile2 = Resolve-Path (Join-Path $PSScriptRoot "input2.txt")
  log-verbose "Input file 2 path: $InputFile2"
}
process {
  if ((get-content $InputFile1) -eq "Placeholder input text file") {
    log "Input 1 data does not exist yet."
  }
  else {
    log "Processing Part 1..."
    $answer = get-content $InputFile1 | Get-Part1Answer

    log "Part 1 Answer:" $answer
  }

  if ((get-content $InputFile2) -eq "Placeholder input text file") {
    log "Input 2 data does not exist yet."
  }
  else {
    log "Processing Part 2..."

    $answer = get-content $InputFile2 | Get-Part2Answer
    log "Part 2 Answer:" $answer
  }
}
end {
  log "Ending processing year 2024 day 07"
}
