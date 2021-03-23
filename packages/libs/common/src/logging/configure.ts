import { AzureLogger, AzureLogLevel, setLogLevel } from "@azure/logger";

/**
 * Configure Autorest Logger.
 * @param level
 */
export function configureLibrariesLogger(level: AzureLogLevel, log: (...args: unknown[]) => void): void {
  setLogLevel(level);
  AzureLogger.log = log;
}
