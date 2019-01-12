<# The location for the user profile in PoSH is referenced by $profile and should be installed in the users Documents directory.
PS C:\Users\khulques\src> $profile
C:\Users\khulques\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
I keep my Windows "dot files" on the windows branch at https://github.com/hulquest/my-stuff
#>
function search-history {
    param([string] $lookfor)
    foreach ($cmd in $(get-history)) {
        $cmdLine=$cmd.CommandLine
        if ($cmdLine.contains($lookfor)) {
            $cmd
        }
    }
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

function Get-Directories
{
	$dirs= Get-ChildItem | Where {$_.psIsContainer -eq $true}
	$dirs |Select name
}

$SrcRoot="c:/users/khulques/OneDrive - NetApp Inc/src"

function To-Src { Set-Location $SrcRoot }

function To-HCIMonitor { Set-Location $SrcRoot/hci-monitor }

function To-SFPrime { Set-Location $SrcRoot/sfprime-hd }

function To-MNodeCfg { Set-Location $SrcRoot/hci-mnodecfg }

function To-Desktop { Set-Location "c:/Users/khulques/Desktop" }

function Unix-LR { Get-ChildItem |Sort-Object -Property LastWriteTime }

function Unix-L { Get-ChildItem |ft Name }

function Load_PowerCli
{
    & 'C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1'
}

$VimVersion="80" # DEPRECATED - Don't really need these with PSReadLineOption and Code as IDE.
$VimExe="c:/program files (x86)/vim/vim"+$VimVersion+"/gvim.exe" # DEPRECATED - Don't really need these with PSReadLineOption and Code as IDE.

# Additions to search path.
$env:path += ";"+"c:/users/khulques/go/bin"
$env:path += ";"+"c:/program files/git/bin"
$env:path += ";"+"c:/python35/scripts"

# Aliases
set-alias gh get-history
set-alias which get-command
set-alias -name vi -value $VimExe
set-alias ld Get-Directories
set-alias lr Unix-LR
set-alias ll Get-ChildItem 
set-alias l Unix-L
set-alias grep select-string
set-alias find get-childitem
set-alias sfp To-SFPrime
set-alias hci To-HCIMonitor
set-alias mnode To-MNodeCfg
set-alias src To-SRC
set-alias ih Invoke-History # DEPRECATED - Don't need these any more with PSReadLineOption
set-alias sh Search-History # DEPRECATED - Don't need these any more with PSReadLineOption
Set-Alias powercli Load_PowerCli

remove-item alias:cd -errora silentlycontinue
remove-item -Force alias:diff -errora silentlycontinue
set-item -path env:GIT_EDITOR -value "vi"

if ($host.Name -eq "ConsoleHost") {
    Import-Module PSReadline
    Set-PSReadlineOption -EditMode Vi 
}