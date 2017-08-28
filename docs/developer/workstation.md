# <img align="center" src="../images/logo.png"> AutoRest - Developer Workstation Requirements

## Build Prerequisites
AutoRest is developed primarily in TypeScript but generates code for multiple languages. To build and test AutoRest requires a few things be installed locally.

## Minimal Required Tools

At a bare minimum, to compile (and run) autorest and run it you will need at least:

### [NodeJS](https://nodejs.org/en/) 7.10.0 or greater

|OS  |Instructions |
|----|--------------------------|
|Windows|You can install the [Node Version Manager for Windows](https://github.com/coreybutler/nvm-windows) <br><br>Install the latest release of the [Node Version Manager](https://github.com/coreybutler/nvm-windows/releases/download/1.1.5/nvm-setup.zip) and then run the following commands:  <br>  `nvm install 7.10.0` <br>  `nvm use 7.10.0` |
|Linux|You can install the [Node Version Manager](https://github.com/creationix/nvm#install-script):<br><br>Run the following commands:<br>`curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash` <br>  `nvm install 7.10.0` <br> `nvm use 7.10.0`|
|OS X|You can install the [Node Version Manager](https://github.com/creationix/nvm#install-script). <br><br>Run the following commands: <br>`touch ~/.bash_profile` <br> `curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash` <br> `nvm install 7.10.0` <br> `nvm use 7.10.0` |

###  [Gulp](https://github.com/gulpjs/gulp) and more

To install all remaining tools required for compilation (including `gulp`), run `npm install` in your clone of the AutoRest repo.

## Recommended Tools

To actually run *all* the tests for all currently supported languages, you'll also need all the following tools and languages installed:

- Visual Studio Code
- Git 
- JDK 8
- Maven
- Gulp
- Ruby 2.3
- Ruby Devkit
  (Windows - also need  missing CA Roots for Ruby)
- Python 2.7
- Python 3.5
- Tox
- Go 
- Glide


## Easy Windows Setup

### Manual Steps
> #### Enable Developer Mode in win10
> In Cortana, search for `developer settings`<br>
> click "Developer Mode", answer "yes"<br>
> scroll down, and click apply, apply, apply<br>
> Close Settings.<br>
> Reboot (win-r `shutdown -r -t 0`)<br>
> #### Use Install Script to install tools
> After Reboot, login then:<br>
> Win-x , `cmd prompt (admin)` -- (ELEVATED!) <br>
> start Powershell and run this command:<br>

``` powershell
   # download the install script and run it.
   iwr https://raw.githubusercontent.com/Azure/autorest/master/Tools/setup-developerworkstation.ps1 -OutFile c:\install-software.ps1 ; c:\install-software.ps1
```
> See the actual script at: https://github.com/Azure/autorest/blob/master/Tools/setup-developerworkstation.ps1 
