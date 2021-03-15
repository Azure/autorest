/**
 * Virtual filesystem, to find and read files.
 */
export interface IFileSystem extends ILegacyFileSystem {
  /**
   * Read the content of the given Uri
   * @param fileUri Uri of the file.
   * @throws {FileSystemError}
   */
  read(fileUri: string): Promise<string>;

  /**
   * List the files in the given folder.
   * @param fileUri Uri of the folder.
   * @throws {FileSystemError}
   */
  list(folderUri: string): Promise<string[]>;
}

export interface ILegacyFileSystem {
  /**
   * @deprecated, use @see {IFileSystem.list}
   */
  EnumerateFileUris(folderUri: string): Promise<Array<string>>;
  /**
   * @deprecated, use @see {IFileSystem.read}
   */
  ReadFile(uri: string): Promise<string>;
}
