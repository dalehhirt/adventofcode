<#
.Description
This script runs.
.LINK
https://adventofcode.com/2024/day/5
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function Process-Part1 {
    [CmdletBinding()]
    param (
      $rules,
      $updates
    )
    
    begin {
      $returnValue = 0
      [System.Collections.ArrayList]$validUpdates = @()
    }
    
    process {
      for ($i = 0; $i -lt $updates.Count; $i++) {
        $updatesInline = $updates[$i]
        $validUpdate = $true
        for ($r = 0; $r -lt $rules.Count; $r++) {
            $rulesBroken = $rules[$r] -split "\|"

            # check if our update line has both sides of a given rule
            if (($updatesInline -contains $rulesBroken[0]) -and
              ($updatesInline -contains $rulesBroken[1])) {
                $firstIndex = $updatesInline.IndexOf($rulesBroken[0])
                $secondIndex = $updatesInline.IndexOf($rulesBroken[1])
                if ($firstIndex -gt $secondIndex) {
                  $validUpdate = $false
                }
            }
        }

        if ($validUpdate) {
          #log "Valid update:" ($updatesInline -join ",")
          $validUpdates.Add($updatesInline) | out-null
        }
      }
    }
    
    end {
      $validUpdates | foreach {
        $validUpdate = $_;
        $middleValue = [System.Math]::Floor($validUpdate.Count / 2)
        $returnValue += [int]$validUpdate[$middleValue]
      }
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
      $ruleSeparator = "\|"
      $updateSeparator = ","
      [System.Collections.ArrayList]$rules = @()
      [System.Collections.ArrayList]$updates = @()
    }
    
    process {
      foreach ($line in $lines) {
        if ($line -match $ruleSeparator) {
          $rules.Add($line) | out-null
        }

        if ($line -match $updateSeparator) {
          $updates.Add(($line -split $updateSeparator)) | out-null
        }
      }
    }
    
    end {
      $returnValue += Process-Part1 -rules $rules -updates $updates
      return $returnValue
    }
  }

  function Reset-Update {
    [CmdletBinding()]
    param (
      [System.Collections.ArrayList]
      $rules,
      [System.Collections.ArrayList]
      $update
    )
    
    begin {
      [System.Collections.ArrayList]$returnValue = @()
    }
    
    process {
      while ($true) {
        
        $rulesChanged = 0

        for ($r = 0; $r -lt $rules.Count; $r++) {
          $rulesBroken = $rules[$r] -split "\|"

          # check if our update line has both sides of a given rule
          if (($update -contains $rulesBroken[0]) -and
            ($update -contains $rulesBroken[1])) {
              $firstIndex = $update.IndexOf($rulesBroken[0])
              $secondIndex = $update.IndexOf($rulesBroken[1])
              if ($firstIndex -gt $secondIndex) {
                $rulesChanged++
                $update.RemoveAt($firstIndex) | out-null
                $update.Insert($secondIndex, $rulesBroken[0]) | Out-Null
              }
          }
        }

        if (0 -eq $rulesChanged) {
          break
        }
      }
    }

    end {
      return $update
    }
  }

  function Process-Part2 {
    [CmdletBinding()]
    param (
      $rules,
      $updates
    )
    
    begin {
      $returnValue = 0
      $invalidUpdates = @{}
      [System.Collections.ArrayList]$validUpdates = @()
    }
    
    process {
      for ($i = 0; $i -lt $updates.Count; $i++) {
        $updatesInline = $updates[$i]
        $validUpdate = $true
        [System.Collections.ArrayList]$brokenRules = @()
        for ($r = 0; $r -lt $rules.Count; $r++) {
            $rulesBroken = $rules[$r] -split "\|"

            # check if our update line has both sides of a given rule
            if (($updatesInline -contains $rulesBroken[0]) -and
              ($updatesInline -contains $rulesBroken[1])) {
                $firstIndex = $updatesInline.IndexOf($rulesBroken[0])
                $secondIndex = $updatesInline.IndexOf($rulesBroken[1])
                if ($firstIndex -gt $secondIndex) {
                  $validUpdate = $false
                }
            }
        }

        if (!$validUpdate) {
          #log "Invalid update:" ($updatesInline -join ",")
          $invalidUpdates.Add($i, $rules) | out-null
        }
      }

      $invalidUpdates.keys | foreach {
        $newUpdate = (Reset-Update -rules $invalidUpdates[$_] -update $updates[$_].Clone())
        #log "Now Valid update:" ($newUpdate -join ",")
        $validUpdates.Add($newUpdate) | out-null
      }
    }
    
    end {
      $validUpdates | foreach {
        #log "Fixed invalid update:" ($updatesInline -join ",")
        $validUpdate = $_;
        $middleValue = [System.Math]::Floor($validUpdate.Count / 2)
        $returnValue += [int]$validUpdate[$middleValue]
      }
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
      $ruleSeparator = "\|"
      $updateSeparator = ","
      [System.Collections.ArrayList]$rules = @()
      [System.Collections.ArrayList]$updates = @()
    }
    
    process {
      foreach ($line in $lines) {
        if ($line -match $ruleSeparator) {
          $rules.Add($line) | out-null
        }

        if ($line -match $updateSeparator) {
          $updates.Add([System.Collections.ArrayList]($line -split $updateSeparator)) | out-null
        }
      }
    }
    
    end {
      $returnValue += Process-Part2 -rules $rules -updates $updates
      return $returnValue
    }
  }

  log "Beginning processing year 2024 day 05"

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
  log "Ending processing year 2024 day 05"
}
