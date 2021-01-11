import winston from "winston";
import { CliConfig } from "./cli/cli-config";

export const logger = winston.createLogger({
  level: "info",
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(winston.format.colorize(), winston.format.simple()),
    }),
  ],
});

export const setLoggingLevelFromConfig = (config: CliConfig): void => {
  const newLevel = config.level ?? (config.debug ? "debug" : config.verbose ? "verbose" : "info");
  logger.level = newLevel;
};
