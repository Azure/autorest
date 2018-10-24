var version=process.versions.node.split(`.`);
if(version[0]<8||(version[0]==8&&version[1]<11)) {
  console.error( `\n\n
*******************************************************************************
  The version of Node.js ${process.versions.node} is not sufficent.
  You need to install Node.js v8.11.0 or greater.

  The prefered version is the current LTS (Long Term Support) version.
  see: https://nodejs.org/en/download/
*******************************************************************************\n\n\n
   `); process.exit(1); }