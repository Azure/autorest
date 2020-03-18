# <img align="center" src="./images/logo.png">  Installing AutoRest

Installing AutoRest on Windows, MacOS or Linux involves two steps:

1. __Install [Node.js](https://nodejs.org/en/)__ (10.15.x LTS preferred. May not function with Node < 10.x Be Wary of 11.x builds as they may introduce instability or breaking changes. ) 
> if you want an easy way to install and update Node, I recommend [NVS - Node Version Switcher](./nodejs/installing-via-nvs.md) or [NVM - Node Version Manager](./nodejs/installing-via-nvm.md)


2. __Install AutoRest__ using `npm`

  ``` powershell
  # Depending on your configuration you may need to be elevated or root to run this. (on OSX/Linux use 'sudo' )
  npm install -g autorest

  # run using command 'autorest'
  autorest --help
  ```
Or the beta version of AutoRest v3, side-by-side:

  ``` powershell
  # Depending on your configuration you may need to be elevated or root to run this. (on OSX/Linux use 'sudo' )
  npm install -g @autorest/autorest

  # run using command 'autorest-beta'
  autorest-beta --help
  ```

### Updating Autorest core 
  To update AutoRest if you have previous versions installed, please run:
    
  ``` powershell
  autorest --latest
  ``` 
or 
  ```powershell
  # Removes all other versions and plugins and installs the latest autorest-core
  autorest --reset
  ```
  For more information, run  `autorest --help`
