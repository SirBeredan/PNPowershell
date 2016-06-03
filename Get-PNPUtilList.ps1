<#
.Synopsis
   Retreives list of installed drivers
.Description
   Parses PNPutil in to an object that can then be used to manipulate drivers.
.EXAMPLE
   Get-PNPutilList | where {$_.Class -eq "Printers"} 
.INPUTS
   None
.OUTPUTS
   Creates object of All 3rd Party PNP Drivers installed in DriveStore
.NOTES
   Requires Windows Vista and Above to use PNPutil.exe
#>
Function Get-PNPutilList
{
    $List = (pnputil -e) | select -Skip 2
    $Props = @{'Name'="";
    'Provider'="";
    'Class'="";
    'Date'="";
    'Signer'=""
    }
    $PNPObject = New-Object -TypeName System.Collections.ArrayList

    for ($Count = 0; $Count -lt $List.Count; $Count = $Count + 6)
    {
        $DriverStore = New-Object PSCustomObject -Property $Props
        $DriverStore.Name=$List[$Count].Split(':')[1].trim()
        $DriverStore.Provider=$List[$Count+1].Split(':')[1].trim()
        $DriverStore.Class=$List[$Count+2].Split(':')[1].trim()
        $DriverStore.Date=$list[$Count+3].Split(':')[1].trim()
        $DriverStore.Signer=$list[$Count+4].Split(':')[1].trim()
        $PNPObject.add($DriverStore) | Out-Null
    }
    return $PNPObject
}