<# The profile for PowerShell ISE lives in a different location than the normal PoSH CLI profile.
 PS C:\Users\khulques> $profile
 C:\Users\khulques\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1
#>
function Set-VsCmd
{
    param(
        [parameter(Mandatory, HelpMessage="Enter VS version as 2010, 2012, or 2013")]
        [ValidateSet(2010,2012,2013)]
        [int]$version
    )
    $VS_VERSION = @{ 2010 = "10.0"; 2012 = "11.0"; 2013 = "12.0" }
    $targetDir = "c:\Program Files (x86)\Microsoft Visual Studio $($VS_VERSION[$version])\VC"
    if (!(Test-Path (Join-Path $targetDir "vcvarsall.bat"))) {
        "Error: Visual Studio $version not installed"
        return
    }
    pushd $targetDir
    cmd /c "vcvarsall.bat&set" |
    foreach {
      if ($_ -match "(.*?)=(.*)") {
        Set-Item -force -path "ENV:\$($matches[1])" -value "$($matches[2])"
      }
    }
    popd
    write-host "`nVisual Studio $version Command Prompt variables set." -ForegroundColor Yellow
}
function Get-UNCPath 
{
    param([string]$drivePath)
    $currentDirectory = Resolve-Path $drivePath
    $currentDrive = Split-Path -qualifier $currentDirectory.Path
    $logicalDisk = Gwmi Win32_LogicalDisk -filter "DriveType = 4 AND DeviceID = '$currentDrive'"
    $currentDirectory.Path.Replace($currentDrive, $logicalDisk.ProviderName)

}
function edit 
{ param ( $Path ) 
             Resolve-path $path | foreach-Object { $null = $psise.CurrentPowerShellTab.Files.add($_.path)} 
}
function goto-poshcode
{
   cd E:\tmp\posh-cloud
}

function Get-NetworkStatistics 
{ 
    $properties = 'PID','Path','Protocol','LocalAddress','LocalPort' 
    $properties += 'RemoteAddress','RemotePort','State'

    netstat -ano | Select-String -Pattern '\s+(TCP|UDP)' | ForEach-Object { 

        $item = $_.line.split(" ",[System.StringSplitOptions]::RemoveEmptyEntries) 

        if($item[1] -notmatch '^\[::') 
        {            
            if (($la = $item[1] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6') 
            { 
               $localAddress = $la.IPAddressToString 
               $localPort = $item[1].split('\]:')[-1] 
            } 
            else 
            { 
                $localAddress = $item[1].split(':')[0] 
                $localPort = $item[1].split(':')[-1] 
            }  

            if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq 'InterNetworkV6') 
            { 
               $remoteAddress = $ra.IPAddressToString 
               $remotePort = $item[2].split('\]:')[-1] 
            } 
            else 
            { 
               $remoteAddress = $item[2].split(':')[0] 
               $remotePort = $item[2].split(':')[-1] 
            }  
            $proc=Get-Process -Id $item[-1] -ErrorAction SilentlyContinue
            $procName= $proc.Name
            $procPath= $proc.Path
            New-Object PSObject -Property @{ 
                PID = $item[-1] 
                Path= $procPath
                #ProcessName=$procName
                Protocol = $item[0] 
                LocalAddress = $localAddress 
                LocalPort = $localPort 
                RemoteAddress =$remoteAddress 
                RemotePort = $remotePort 
                State = if($item[0] -eq 'tcp') {$item[3]} else {$null} 
            } | Select-Object -Property $properties 
        } 
    } 
}
function prompt
{
    $dirName = Get-Item .
	"PS [${dirName.Name}] > "
}
function Get-Directories
{
	$dirs= Get-ChildItem | Where {$_.psIsContainer -eq $true}
	$dirs |Select name
}
function To-AppAware
{
	Set-Location c:/_AppAware
}

function To-RG
{
	Set-Location c:/_AppAware/SCOM/RecoveryGuru/SantricitySrc\SYMsm\SYMsm\devmgr\versioned\sam\recoveryguru
}

function To-SCOM
{
	Set-Location c:/_AppAware/SCOM
}

function To-SRC
{
	Set-Location c:/_AppAware/SCOM/src/svn
}

function To-SYMbol
{
	Set-Location $sbma/SBMA_SYMbol_Adapter
}

function To-ProdConfig
{
	Set-Location $sbma/SBMA_Product_Config
}

function To-Tools
{
	Set-Location $sbma/SBMA_Tools
}
function To-Desktop
{
	Set-Location "c:/Documents And Settings/khulques/Desktop"
}
function To-Rest
{
	Set-Location "E:\src\projects\restapi"
}
function To-OEM
{
	Set-Location "E:\src\projects\OEM3.2\projects\OEMPlugin"
}

function diff 
{
    param([Parameter(position=0,Mandatory=$true)][string]$FirstFile,
          [Parameter(position=1,Mandatory=$true)][string]$SecondFile)
    $File1 = Get-Item $FirstFile
    $File2 = Get-Item $SecondFile
    if ($File1.Exists -eq $false) 
    {
        throw "$FirstFile does not exist" 
    }
    if ($File2.Exists -eq $false) 
    {
        throw "$SecondFile does not exist"
    }
    Compare-Object $( Get-Content $FirstFile ) $( Get-Content $SecondFile)
}
function Reload {

    $CurrentFile = $psise.CurrentFile
    $FilePath = $CurrentFile.FullPath

    $lineNum = $psise.CurrentFile.Editor.CaretLine
    $colNum = $psise.CurrentFile.Editor.CaretColumn

    $PsISE.CurrentPowerShellTab.Files.remove($CurrentFile) > $null

    $newFile = $PsISE.CurrentPowerShellTab.Files.add($FilePath)

    $newfile.Editor.SetCaretPosition($lineNum,$colNum)
}

Set-Alias posh goto-poshcode
Set-Alias rest To-Rest
Set-Alias oem To-OEM 

. "C:\Documents and Settings\khulques\My Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

$psISE.CurrentPowerShellTab.AddOnsMenu.SubMenus.Clear()
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add("Reload File",{Reload},'f4') > $null

# Import-Module PSReadline
# Set-PSReadlineOption -EditMode Vi 