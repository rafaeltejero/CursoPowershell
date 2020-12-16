#/**
#* ... Powershell App...
#*/

# Parámetros de entrada
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True, Position = 1)]
    [String]$exeMode,
    [Parameter(Mandatory = $False, Position = 2)]
    [String]$package    
)


# Averiguamos directorio base
$scriptFile = $myInvocation.MyCommand.Definition
$arrPartsScriptFile = $scriptFile.Split("\")

$global:scriptName = (($arrPartsScriptFile[$arrPartsScriptFile.Length - 1]).Split("."))[0]
$global:baseDir = (get-item $scriptFile).Directory.Parent.FullName
$global:exeMode = $exeMode

. "$global:baseDir\code\functions.ps1"

StartScript

$performanceValues = @()
$counter = "\Processor(_Total)\% Processor Time"
Get-Counter -Counter $counter -SampleInterval 2 -MaxSamples 3 | foreach {
    $timeStamp = $_.Timestamp
    $value = $_.CounterSamples[0].CookedValue

    $item = new-object psobject
    $item | add-member noteproperty TimeStamp $timeStamp
    $item | add-member noteproperty Value $value

    $performanceValues += $item
    $global:Result.Output += $item
}

$performanceValues | Export-Csv -Path "$global:baseDir\data\dat-$global:baseDateMain.csv"

StopScript
