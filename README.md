# my-stuff
This is a repository I use to track my dot files.  I have to work on a corporate laptop with a Windows 10 image so I get into the Windows toolchain, particularly the PowerShell ecosystem when I am disconnected from my linux dev environment.

I have a [Linux setup file](https://gist.github.com/hulquest/7b370ebd5ca482a001fe30805c372710) that will bootstrap a new system.  

## Branches
I use branches to separate the development environments I work with.  A corporate Windows laptop and Linux desktop.  This is also very helpful when I have some work to do on a VM.
### Linux
The **__master__** branch is the general purpose Linux dot files I use.  I use it most often so it has the designation of **master**

### Windows
The **__windows__** branch has my PowerShell startup files.  There is no bootstrapping script for Windows at this time.  Although it is on my [list of things to do](https://github.com/hulquest/my-stuff/issues/1) for the project.

### Windows SubSystem for Linux
[With the resolution of #2](https://github.com/hulquest/my-stuff/issues/2) there is support in the .bash_aliases file to branch on the type of Linux shell.

### Linux Setup
Get helm 3
``` curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash ```
