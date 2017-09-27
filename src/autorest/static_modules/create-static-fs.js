const fs = require("fs");

let txt = fs.readFileSync('./node_modules/npm/lib/install/action/extract.js',"utf8").replace("const ENABLE_WORKERS = process.platform === 'darwin'", "const ENABLE_WORKERS = false;");
fs.writeFileSync('./node_modules/npm/lib/install/action/extract.js', txt );


function getFileNames(path, result) {
  const files = fs.readdirSync(path);
  for (const file of files) {
    const full = `${path}/${file}`;
    const stat = fs.statSync(full);
    if ( stat.isDirectory()) {
      getFileNames(full, result)
    } else {
      result[full] = stat;
    }
  }
  return result;
}

const intBuffer = Buffer.alloc(6);
function writeIntAt(fd, num, offset) {
  intBuffer.writeIntBE(num, 0, 6 );
  writeBufferAt(fd, intBuffer,offset);
}

function writeBufferAt(fd,buffer,offset) {
//   return new Promise((r,j)=> fs.write(fd,buffer,0,buffer.length,offset,(err,bytes)=> err ? j(err, console.log("BAD")): r(bytes)));
  fs.writeSync( fd, buffer, 0, buffer.length, offset);
}

// async function main() {
  const files = getFileNames(`./node_modules`,{});
  const fd = fs.openSync("../dist/static_modules.fs","w");
  
  // write payload offset
  writeIntAt(fd,0,0);
  
  let tablesize = 6;
  
  // create a static fs
  for(const each in files)  {
    
    const name = Buffer.from(each.replace(/^./, ''), 'utf-8');
    const size = files[each].size;
    writeIntAt(fd, name.length,tablesize); // size of name 
    writeIntAt(fd, files[each].size,tablesize+6); // size of file
    writeBufferAt(fd, name,tablesize+12); // actual name
    
    tablesize+=12 + name.length;
  }
  // write end of table
  writeIntAt(fd,0,tablesize);
  tablesize+=6;
  
  // write data offset start 
  writeIntAt(fd, tablesize,0);
  
  
  datasize = tablesize;
  
  // write files out
  for(const each in files)  {
    const buf =  fs.readFileSync(each);
//    console.log(`${each}  => ( @${datasize} , ${files[each].size},  ) `);
    writeBufferAt(fd, buf,datasize);
    datasize += files[each].size;
  }
  fs.close(fd,()=> console.log('done'));
// }


