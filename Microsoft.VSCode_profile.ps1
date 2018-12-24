<# The profile for PowerShell ISE lives in a different location than the normal PoSH CLI profile.
 PS C:\Users\khulques> $profile
 C:\Users\khulques\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1
#>
. "C:\Documents and Settings\khulques\My Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
function prompt
{
    $dirName = Get-Item .
	"CODE [${dirName.Name}] > "
}