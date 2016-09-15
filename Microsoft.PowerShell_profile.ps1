function search-history {
    param([string] $lookfor)
    foreach ($cmd in $(get-history)) {
        $cmdLine=$cmd.CommandLine
        if ($cmdLine.contains($lookfor)) {
            $cmd
        }
    }
}
function ses {
    & svn status |select-string "^\?" -NotMatch
}

function diff {
    param(
    [string] $file1,
    [string] $file2)
    Compare-Object -ref $(get-content $file1) -diff $(get-content $file2)
}
function cd {
	
    if ($args[0] -eq '-') {
        $pwd=$OLDPWD;
   } else {
        $pwd=$args[0];
    }
    
    $tmp=pwd;

    if ($pwd) {
    Set-Location $pwd;
    }

    Set-Variable -Name OLDPWD -Value $tmp -Scope global;
}

function prompt
{
   $dirName = Get-Item .
	"PS [$($(Get-Item .).Name)] > "
}

function Start-Derby 
{
    $block = {cd $env:derby_home/bin; ./startNetworkServer.bat}
    $job = start-job -scriptblock $block
    receive-job -job $job
}

function Get-Checksum($file, $crypto_provider) {
	if ($crypto_provider -eq $null) {
		$crypto_provider = new-object 'System.Security.Cryptography.MD5CryptoServiceProvider';
	}		

	$file_info	= get-item $file;
	trap { ;
	continue } $stream = $file_info.OpenRead();
	if ($? -eq $false) {
		return $null;
	}

	$bytes		= $crypto_provider.ComputeHash($stream);
	$checksum	= '';
	foreach ($byte in $bytes) {
		$checksum	+= $byte.ToString('x2');
	}

	$stream.close() | out-null;

	return $checksum;
}

function Get-Version
{
    param([String] $FileName)
    if ($FileName -eq "" -or $FileName -eq $null)
    {
        Write-Host("Usage: Get-Version <fileName>")
        return -1
    }
    else
    {
        $File=Get-Item $FileName -ErrorAction SilentlyContinue -ErrorVariable errStr
        if ($? -eq $false) { 
            Write-Host "File does not exist. $errStr" 
            return -1
        }
        [System.Diagnostics.FileVersionInfo]::GetVersionInfo($File.FullName).FileVersion
    }

}
function sqlcmd
{
    & "c:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE" -S bolkhulques03\HULQUEST -d StorageExplorer -w 100
}
function Get-Directories
{
	$dirs= Get-ChildItem | Where {$_.psIsContainer -eq $true}
	$dirs |Select name
}
function To-AppAware
{
	Set-Location c:/users/khulques/workspace
}

function Sync-SVN
{
	$src="C:\_AppAware\SCOM\src"
	$svn=$src+"\svn-clean"
	$view= "\KMH_View\vob\IBP_Appaware\SCOM"
	$ccrc=$src+$view
	. c:\_AppAware\SCOM\src\Sync-CCRC.ps1 -svn $svn -cc $ccrc
}

function To-ClearCaseView
{
	Set-Location c:/_AppAware/SCOM/src/KMH_View/vob/IBP_Appaware/SCOM
}

function To-RG
{
	Set-Location c:/_AppAware/SCOM/RecoveryGuru/SantricitySrc\SYMsm\SYMsm\devmgr\versioned\sam\recoveryguru
}

function To-DCSF
{
	Set-Location c:/_AppAware/DCSF/src
}

function To-SCOM
{
	Set-Location c:/netapp/projects/scom
}

function To-SRC
{
	Set-Location c:/_AppAware/SSMS/SSMS-Trunk/Client
}

function To-SSMSI3
{
	Set-Location c:/_AppAware/SSMS/SSMS-I3
}

function To-SSMS 
{
	Set-Location c:/_AppAware/SSMS/SSMS-Trunk
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
function Unix-LR
{ 
	Get-ChildItem |Sort-Object -Property LastWriteTime
}
function Unix-L
{ 
	Get-ChildItem |ft Name
}
#set-location c:/_appaware
set-alias gh get-history
set-alias which get-command
set-alias vi "c:/program files (x86)/vim/vim74/gvim.exe"
set-alias ld Get-Directories
set-alias lr Unix-LR
set-alias ll Get-ChildItem 
set-alias l Unix-L
set-alias grep select-string
set-alias src To-SRC
set-alias trunk To-SSMS
set-alias i3 To-SSMSI3
set-alias find get-childitem
$env:path += ";c:\program files\microsoft\visual studio 9.0\vc\bin;c:\ant\bin"
$env:path += ";c:\windows\microsoft.net\framework\v3.5"
$env:path += ";e:/bin/scripts/posh"
$env:psmodulepath += ";C:\Program Files\NetApp\Modules\NetApp.SANtricity.PowerShell"
$sbma="C:\users\khulques\workspace\khulques_IBP_SBMA_EXT_EAGLE6.0_Dev_Work\vobs\app_SBMA"

set-alias scom To-Scom 
set-alias dcsf To-DCSF 
set-alias rg To-RG
set-alias ws To-AppAware 
set-alias desktop To-Desktop 
set-alias symbol To-SYMbol 
set-alias pc To-ProdConfig
set-alias tools To-Tools 
set-alias ccrc To-ClearCaseView
set-alias ih Invoke-History
set-alias sh Search-History
set-alias as Add-PSSnapin
remove-item alias:cd -errora silentlycontinue
remove-item -Force alias:diff -errora silentlycontinue
set-item -path env:SVN_EDITOR -value "vi"
