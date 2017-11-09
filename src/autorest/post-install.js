try {
  for( const each in process.env) {
    if( each.startsWith("npm_config") || each.startsWith("npm_lifecycle") || each.startsWith("npm_package") ) {
      delete process.env[each];
    }
  }
  // if this installed for development
  // static-link should be installed. 
  // if we require it, it should build the static fs.
  require("./node_modules/static-link/dist/static-link");
} catch(E) { }

