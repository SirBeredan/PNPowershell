<#
.Synopsis
   Removes all WHQL Signed 3rd party Print Drivers
.Description
   Uses Get-PNPUtilList.ps1 to create a PNPObject which then deletes all installed 3rd Party Print Drivers.
.EXAMPLE
  Remove-PNPPrintDrivers.ps1
.NOTES
   Requires Windows Vista and Above to use PNPutil.exe
#>
. .\Get-PNPutilList.ps1
$PNPObject = Get-PNPutilList | where {$_.Class -eq "Printers"} | where {$_.Signer -eq "Microsoft Windows Hardware Compatibility Publisher"}
foreach ($PNPitem in $PNPObject)
{
    $DriverName = $PNPItem.name
    pnputil -d $DriverName
}
Restart-Service -Name Spooler
$Service = Get-Service -Name Spooler
If (($Service.status) -eq "Running")
{
    write-host "Print Spool Is Running" -ForegroundColor Green
}
else
{
    write-host "Print Spooler Is Not Running" -ForegroundColor Red
}
