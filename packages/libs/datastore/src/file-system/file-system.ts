import { ReadUri } from "@azure-tools/uri";

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

const MAX_RETRY_COUNT = 3;
/**
 * ReadUri with retries in the case of a remote url and retryable http error.
 * @param uri uri
 * @param headers optional headers for the request.
 */
export async function readUriWithRetries(uri: string, headers: { [name: string]: string } = {}): Promise<string> {
  let tryed = 1;
  for (;;) {
    try {
      return await ReadUri(uri, headers);
    } catch (e) {
      tryed++;
      if (isRetryableStatusCode(e.statusCode) && tryed <= MAX_RETRY_COUNT) {
        // eslint-disable-next-line no-console
        console.error(`Failed to load uri ${uri}, trying again (${tryed}/${MAX_RETRY_COUNT})`, e);
      } else {
        throw e;
      }
    }
  }
}

/**
 * @param statusCode Error status code.
 * @returns Boolean if this request should be retried.
 */
function isRetryableStatusCode(statusCode: number): boolean {
  return statusCode >= 500 || statusCode === 0;
}
