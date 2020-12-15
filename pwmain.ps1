#/**
#* ... Powershell App...
#*/

# Parámetros de entrada
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True, Position = 1)]
    [String]$exeMode
)


# Averiguamos directorio base
$scriptFile = $myInvocation.MyCommand.Definition
$arrPartsScriptFile = $scriptFile.Split("\")

$global:scriptName = (($arrPartsScriptFile[$arrPartsScriptFile.Length - 1]).Split("."))[0]
$global:baseDir = (get-item $scriptFile).Directory.Parent.FullName
$global:exeMode = $exeMode

. "$global:baseDir\code\functions.ps1"

StartScript

Msg "Inf" "Starting Process"

$ArrObj = @()
$value = 0
for ($c=1;$c -le 10;$c++) {
    for ($d=1;$d -le 10;$d++) {
        $item = new-object psobject
        $item | add-member noteproperty Name "Nombre $d"
        $item | add-member noteproperty Descripction "El nombre $d"
        $item | add-member noteproperty Value $value
        $item | add-member noteproperty Grupo "G$c"
        $value = $value + 1

        $ArrObj += $item
    }
}
$ArrObj | Sort-Object -Descending -Property Value  | Format-Table -GroupBy Grupo

 $global:Result.Output += $ArrObj

Msg "Inf" "End Process"

StopScript