export class FileSystemError extends Error {}

/**
 * Error representing a uri not found.
 */
export class UriNotFoundError extends FileSystemError {
  public constructor(public uri: string, message?: string) {
    super(message ?? `${uri} not found.`);
  }
}
