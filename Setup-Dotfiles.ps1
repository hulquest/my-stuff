function Make-Backup(){
    param([string]$SourceDir, 
          [string]$TargetDir,
          [string[]]$ExcludeList
    )
    Get-ChildItem -Path $SourceDir -Exclude $ExcludeList | `
        Where-Object {$_.GetType().Name -eq "FileInfo"} | `
        ForEach-Object {Move-Item -Path $_ -Destination $TargetDir}
}

function Add-GitRepository(){
    & git init .
    & git remote add origin git@github.com:hulquest/my-stuff.git 
    & git fetch 
    & git checkout -b windows
    & git pull origin windows
    & git config --local status.showUntrackedFiles no
}

$HomeDir = Split-Path $profile
$BackupDirName=".config-backup"
$BackupDir="$HomeDir/${BackupDirName}" 
if (-Not $(Test-Path $BackupDir)) {
    $BackupDir=New-Item -ItemType Directory -Path $HomeDir -Name $BackupDirName -ErrorAction SilentlyContinue
}
Make-Backup -SourceDir $HomeDir -TargetDir $BackupDir -ExcludeList $($MyInvocation.MyCommand.Name)

Add-GitRepository