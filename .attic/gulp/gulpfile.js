// set the base folder of this project
global.basefolder = `${__dirname}`
require ("rechoir").prepare(require('interpret').extensions, './.gulp/gulpfile.iced');
require ('./.gulp/gulpfile.iced')
