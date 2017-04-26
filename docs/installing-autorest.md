
# Installing Autorest 

Installing AutoRest on Windows, MacOS or Linux involves two steps:

1. __Install [Node.js](https://nodejs.org/en/)__ (6.9.5 or greater)
> for more help, check out [Installing Node.JS on different platforms](./developer/workstation.md#nodejs)

2. __Install AutoRest__ using `npm`

  ``` powershell
  # Depending on your configuration you may need to be elevated or root to run this. (on OSX/Linux use 'sudo' )
  npm install -g autorest
  ```

### Updating Autorest
  To update AutoRest if you have previous versions installed, please run:
    
  ``` powershell
  autorest --latest
  ``` 
or 
  ```powershell
  # Removes all other versions and installs the latest
  autorest --reset
  ```
  For more information, run  `autorest --help`
