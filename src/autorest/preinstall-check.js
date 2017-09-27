var version=process.versions.node.split(`.`); 
if(version[0]<7||(version[0]==7&&version[1]<10)) {
  console.error( `\n\n
***************************************************
  The version of Node.js ${process.versions.node} is not sufficent. 
  You need to install Node.js v7.10.0 or greater.

  see https://nodejs.org/download/release/v7.10.1/
***************************************************\n\n\n
   `); process.exit(1); }