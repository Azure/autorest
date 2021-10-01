/**
 * Yargs is missing helpers definitions.
 */
declare module "yargs/helpers" {
  export const hideBin: (argv: string[]) => string[];
}
