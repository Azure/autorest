/**
 * Virtual filesystem, to find and read files.
 */
export interface IFileSystem extends ILegacyFileSystem {
  read(fileUri: string): Promise<string>;
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
