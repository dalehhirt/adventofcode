<#
.Description
--- Day 1: Trebuchet?! ---
Something is wrong with global snow production, and you've been selected to take a look. The Elves have even given you a map; on it, they've used stars to mark the top fifty locations that are likely to be having problems.

You've been doing this long enough to know that to restore snow operations, you need to check all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

You try to ask why they can't just use a weather machine ("not powerful enough") and where they're even sending you ("the sky") and why your map looks mostly blank ("you sure ask a lot of questions") and hang on did you just say the sky ("of course, where do you think snow comes from") when you realize that the Elves are already loading you into a trebuchet ("please hold still, we need to strap you in").

As they're making the final adjustments, they discover that their calibration document (your puzzle input) has been amended by a very young Elf who was apparently just excited to show off her art skills. Consequently, the Elves are having trouble reading the values on the document.

The newly-improved calibration document consists of lines of text; each line originally contained a specific calibration value that the Elves now need to recover. On each line, the calibration value can be found by combining the first digit and the last digit (in that order) to form a single two-digit number.

For example:

1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.

Consider your entire calibration document. What is the sum of all of the calibration values?#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()
begin {
  function log() {
    write-host ">>> [$($env:COMPUTERNAME)]" ((Get-Date).ToUniversalTime().ToString('u')) "$args" -ForeGroundColor Green
  }
  
  function log-verbose() {
    write-verbose ">>> [$($env:COMPUTERNAME)] $((Get-Date).ToUniversalTime().ToString('u')) $args"
  }
  
  function log-error() {
    write-error ">>> [$($env:COMPUTERNAME)] $((Get-Date).ToUniversalTime().ToString('u')) $args"
  }

  function Get-TrueNumberValue() {
    param($value)
    if($numberHash.Contains($value)) {
      return $numberHash[$value]
    }
    return $value
  }

  function Get-NumberValue2(){
    param($line)
    $originalLine = $line

    $returnMatches = @()
    while("" -ne $line) {
      if($line[0] -match "\d") {
        $returnMatches += $line[0]
      }
      else {
        foreach ($key in $numberHash.Keys) {
          if($line -match "^$key") {
            $returnMatches += $key
          }
        }
      }
      $line = $line.Substring(1)
    } 
    
    $returnString = (Get-TrueNumberValue $returnMatches[0]) + (Get-TrueNumberValue $returnMatches[-1])
    # log "Matches found:" ($returnMatches -join ",")
    # log "$originalLine -> $returnString"
    [int]$returnString
  }

  function Get-NumberValue1(){
    param($line)
    
    $regex = "\d"
    $returnMatches = [regex]::Matches($line, $regex)
    $returnString = $returnMatches[0].Value + $returnMatches[-1].Value
    #log "$line -> $returnString"
    [int]$returnString
  }
  #-----------------
  # Global Variables
  $InputFile = Resolve-Path (Join-Path $PSScriptRoot "input.txt")
  $SumOfCalibrationValues = 0
  $numberHash = [ordered]@{"one"="1";
    "two"="2";
    "three"="3";
    "four"="4";
    "five"="5";
    "six"="6";
    "seven"="7";
    "eight"="8";
    "nine"="9"}
}
process {
  get-content $InputFile | ForEach-Object {
    $Line = $_
    $SumOfCalibrationValues += Get-NumberValue1 $Line
  }
  log "1st Total Sum of all Calibration Values:" $SumOfCalibrationValues
  
  $SumOfCalibrationValues = 0
  get-content $InputFile | ForEach-Object {
    $Line = $_
    $SumOfCalibrationValues += Get-NumberValue2 $Line
  }
  log "2nd Total Sum of all Calibration Values:" $SumOfCalibrationValues
}
end {
}