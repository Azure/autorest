import { enumerateFiles, readUri, writeString } from "@azure-tools/uri";
import { IFileSystem } from "./file-system";
import * as Constants from "../constants";
import { UriNotFoundError } from "./errors";
import { logger } from "../logger";

export class RealFileSystem implements IFileSystem {
  public constructor() {}

  public list(folderUri: string): Promise<Array<string>> {
    return enumerateFiles(folderUri, [Constants.DefaultConfiguration]);
  }

  public async read(uri: string, headers: { [name: string]: string } = {}): Promise<string> {
    return await readUriWithRetries(uri, headers);
  }

  public async write(uri: string, content: string): Promise<void> {
    return writeString(uri, content);
  }

  /**
   * @deprecated
   */
  public async ReadFile(uri: string): Promise<string> {
    return this.read(uri);
  }

  /**
   * @deprecated
   */
  public async EnumerateFileUris(folderUri: string): Promise<Array<string>> {
    return this.list(folderUri);
  }
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
      return await readUri(uri, headers);
    } catch (e) {
      tryed++;
      if (isRetryableStatusCode(e.statusCode) && tryed <= MAX_RETRY_COUNT) {
        // eslint-disable-next-line no-console
        logger.error(`Failed to load uri ${uri}, trying again (${tryed}/${MAX_RETRY_COUNT})`, e);
      } else {
        throw processError(uri, e);
      }
    }
  }
}

export const KnownUriErrorCode = {
  NotFound: "ENOTFOUND",
};

/**
 * @param statusCode Error status code.
 * @returns Boolean if this request should be retried.
 */
function isRetryableStatusCode(statusCode: number): boolean {
  return statusCode >= 500 || statusCode === 0;
}

/**
 * Convert external errors into known error types when able.
 * @param uri Uri that was loaded.
 * @param error Error.
 * @returns new error if error is known or the same error otherwise.
 */
function processError(uri: string, error: Error) {
  if (isCodeError(error)) {
    if (error.code === KnownUriErrorCode.NotFound) {
      return new UriNotFoundError(uri, `${uri} is not found: ${error.message}`);
    }
  }
  return error;
}

interface CodeError extends Error {
  code: string;
}

function isCodeError(error: unknown): error is CodeError {
  return typeof error === "object" && error != null && "code" in error && (error as any)["code"] != null;
}
