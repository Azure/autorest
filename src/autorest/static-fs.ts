import { dirname } from 'path';
import { Stats } from 'fs';

const fs_readFileSync = require("fs").readFileSync;
const fs_openSync = require("fs").openSync;
const fs_readSync = require("fs").readSync;
const fs_statSync = require("fs").statSync;
const fs_realpathSync = require("fs").realpathSync;
const fs_closeSync = require("fs").closeSync;

const correctPath = require("./fs-monkey/correctPath.js").correctPath;

interface Index {
  [filepath: string]: Stats;
}

function addParentPaths(name: string, index: any): any {
  const parent = dirname(name);
  if (parent && !index[parent]) {
    index[parent] = <Stats>{
      size: 0,
      isDirectory: () => true,
      isSymbolicLink: () => false,
      isBlockDevice: () => false,
      isCharacterDevice: () => false,
      isFile: () => false,
      isFIFO: () => false,
      isSocket: () => false,
      dev: 0,
      ino: 0,
      mode: 0,
      nlink: 0,
      uid: 0,
      gid: 0,
      rdev: 0,

      blksize: 1,
      blocks: 0,
      atimeMs: 1,
      mtimeMs: 1,
      ctimeMs: 1,
      birthtimeMs: 1,
      atime: new Date(),
      mtime: new Date(),
      ctime: new Date(),
      birthtime: new Date(),
    }
    return addParentPaths(parent, index);
  }
  return index;
}

class StaticFileSystem {
  private intBuffer = Buffer.alloc(6);
  private buf = Buffer.alloc(1024 * 128); // 128k by default.
  index: Index = {};
  private fd: number;

  private readBuffer(buffer: Buffer, length?: number): number {
    return fs_readSync(this.fd, buffer, 0, length || buffer.length, null);
  }

  private readInt(): number {
    fs_readSync(this.fd, this.intBuffer, 0, 6, null);
    return this.intBuffer.readIntBE(0, 6);
  }

  public shutdown() {
    fs_closeSync(this.fd);
    this.index = <Index>{};
  }

  readFile(filepath: string): string | undefined {
    const item = this.index[filepath];
    if (item && item.isFile()) {
      // realloc if necessary
      while (this.buf.length < item.size) {
        this.buf = Buffer.alloc(this.buf.length * 2);
      }

      // read the content and return a string
      fs_readSync(this.fd, this.buf, 0, item.size, item.ino);
      return this.buf.toString("utf-8", 0, item.size);
    }
    return undefined;
  }

  public constructor(private sourcePath: string) {
    // read the index
    this.fd = fs_openSync(sourcePath, 'r');
    // close on process exit.
    let dataOffset = this.readInt();

    do {
      const nameSz = this.readInt();
      if (nameSz == 0) {
        break;
      }
      const dataSz = this.readInt();
      while (nameSz > this.buf.length) {
        this.buf = Buffer.alloc(this.buf.length * 2);
      }
      this.readBuffer(this.buf, nameSz);
      const name = this.buf.toString('utf-8', 0, nameSz);

      // add entry for file into index
      this.index[name] = <Stats>{
        ino: dataOffset,
        size: dataSz,
        isDirectory: () => false,
        isSymbolicLink: () => false,
        isBlockDevice: () => false,
        isCharacterDevice: () => false,
        isFile: () => true,
        isFIFO: () => false,
        isSocket: () => false,
      }
      // ensure parent path has a directory entry
      addParentPaths(name, this.index);
      dataOffset += dataSz;
    } while (true)

  }
}

export class StaticVolumeSet {
  private fileSystems: Array<StaticFileSystem> = [];

  public shutdown() {
    for (const fsystem of this.fileSystems) {
      fsystem.shutdown();
    }
  }

  public constructor(sourcePath: string, private fallbackToDisk: boolean = false) {
    this.addFileSystem(sourcePath);
  }

  public addFileSystem(sourcePath: string): StaticVolumeSet {
    this.fileSystems.push(new StaticFileSystem(sourcePath));
    return this;
  }

  public readFileSync(filepath: string, options: any): string | Buffer {

    const targetPath: string = correctPath(filepath);

    for (const fsystem of this.fileSystems) {
      const result = fsystem.readFile(targetPath);
      if (result != undefined) {
        return result;
      }
    }

    if (this.fallbackToDisk) {
      return fs_readFileSync(filepath, options);
    }

    throw new Error(`statSync - no file found ${filepath}`);
  }

  public realpathSync(filepath: string): string {
    const targetPath: string = correctPath(filepath);
    for (const fsystem of this.fileSystems) {
      const result = fsystem.index[targetPath];
      if (result) {
        return targetPath;
      }
    }
    return fs_realpathSync(filepath);
  };

  public statSync(filepath: string): Stats {
    const targetPath: string = correctPath(filepath);

    for (const fsystem of this.fileSystems) {
      const result = fsystem.index[targetPath];
      if (result) {
        return result;
      }
    }
    if (this.fallbackToDisk) {
      return fs_statSync(filepath);
    }

    throw new Error(`statSync - no file found ${filepath}`);
  }
}