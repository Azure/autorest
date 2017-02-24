# <img align="center" src="../images/logo.png"> AutoRest - Developer Workstation Requirements

## Build Prerequisites
AutoRest is developed primarily in C# but generates code for multiple languages. To build and test AutoRest requires a few things be installed locally.

## Minimal Required Tools

At a bare minimum, to compile autorest and run it you will need at least:

### The .NET CLI tools

##### Required: [.NET CLI](https://github.com/dotnet/cli#installers-and-binaries) tools build -004812 or later (after 02/14/2017)

> You want the **.NET Core SDK Binaries** for your platform <br>
>
> `dotnet --version ` <br>
> ` 1.0.0-rc4-004812 ` <br>

### NodeJS

#### Required: [Node.js](https://nodejs.org/en/) 6.9.5 or greater

| |Most Users ![image](/docs/images/normal.png) |Technical Users ![image](/docs/images/glasses.png)|
|-|:--|:------------------------------------------------------------------|
|Windows|Install [Latest NodeJS LTS build](https://nodejs.org/en/download/ ) using the <br>Windows installer.|You can install the [Node Version Manager for Windows](https://github.com/coreybutler/nvm-windows) <br><br>Install the latest release of the [Node Version Manager](https://github.com/coreybutler/nvm-windows/releases/download/1.1.2/nvm-setup.zip) and then run the following commands:  <br>  `nvm install 6.10.0` <br>  `nvm use 6.10.0` |
|Linux|Install [Latest NodeJS LTS build](https://nodejs.org/en/download/package-manager/) via the<br> package manager instructions for <br>your version of Linux|You can install the [Node Version Manager](https://github.com/creationix/nvm#install-script):<br><br>Run the following commands:<br>`curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash` <br>  `nvm install 6.10.0` <br> `nvm use 6.10.0` |
|OS X|Install [Latest NodeJS LTS build](https://nodejs.org/en/download/ ) using<br> the Macintosh installer<br><br>or<br><br>Use the [Instructions using a package manager](https://nodejs.org/en/download/package-manager/#osx)|You can install the [Node Version Manager](https://github.com/creationix/nvm#install-script). <br><br>Run the following commands: <br>`touch ~/.bash_profile` <br> `curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash` <br> `nvm install 6.10.0` <br> `nvm use 6.10.0` |

###  [Gulp](https://github.com/gulpjs/gulp) 

##### Required: version 3.9.1

``` powershell
# Install Globally using 'npm': (may require root/admin depending on your configuration)
npm install -g gulp 
```
 
---

## Recommended Tools

To actually run all the tests for the different languages, you'll also need all the tools and languages installed for your workstation:

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


## Easy Linux Setup

(coming soon)

## Easy OS X Setup

(coming soon)
