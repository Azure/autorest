# Building AutoRest 

## Cloning this repository
Clone the repository 

> `git clone https://github.com/Azure/autorest` 

It is *not* necessary to clone recursively (`--recurse`) - that is only needed for advanced scenarios.

## Prerequisites
Install [Node.js](https://nodejs.org/en/) (10.16.x LTS HIGHLY RECOMENDED) 
> for more help, check out [Installing Node.JS on different platforms](./docs/developer/workstation.md#nodejs)

Install [Rush](https://rushjs.io/pages/intro/welcome/) to manage the build process:
> `npm install -g "@microsoft/rush" `


## Preparation 
The first time (or after pulling from upstream) use `rush` to install dependencies 
> `rush update`

## Compiling AutoRest
Use `rush` to build packages
> `rush rebuild`


## Other `rush` commands

### Cleaning output folder
> `rush clean`

### Running test scripts
> `rush test` -- runs the unit tests.

### Ensuring that packge versions are synchronized across projects

> `rush sync-versions` -- will make sure that dependent packages versions are consistent across sub-projects

### Using watch mode to compile on save 

> `rush watch` -- will watch for changes on disk and recompile.

