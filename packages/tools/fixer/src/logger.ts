import winston, { format } from "winston";
import { CliConfig } from "./cli/cli-config";

export const logger = winston.createLogger({
  level: "info",
  format: winston.format.combine(
    winston.format.splat(),
    winston.format.errors({ stack: true }),
    winston.format.colorize(),
    winston.format.printf(({ level, message, stack, padding }) => {
      padding = (padding && padding[level]) || "";
      if (stack) {
        // print log trace
        return `${level}: ${message} - ${stack}`;
      }
      return `${level}: ${message}`;
    }),
  ),
  transports: [new winston.transports.Console({})],
});

export const setLoggingLevelFromConfig = (config: CliConfig): void => {
  const newLevel = config.level ?? (config.debug ? "debug" : config.verbose ? "verbose" : "info");
  logger.level = newLevel;
};
