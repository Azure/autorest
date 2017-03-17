export interface IFileSystem {
  readonly RootUri: string;
  EnumerateFiles(): Promise<Array<string>>;
  ReadFile(path: string): Promise<string>;
  WriteFile(path: string, content: string): Promise<void>;
}

