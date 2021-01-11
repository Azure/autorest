import mustache from "mustache";
import { TemplateContext } from "../models/template-context";

/**
 * Format all the headers.
 * @param headers Headers to format.
 * @param context Context.
 */
export const processResponseHeaders = (
  headers: { [key: string]: string },
  context: TemplateContext,
): { [key: string]: string } => {
  const result: { [key: string]: string } = {};
  for (const [key, value] of Object.entries(headers)) {
    result[key] = render(value, context);
  }
  return result;
};

/**
 * Process the given template using the provided context.
 * @param template Template to format.
 * @param context Context.
 * @returns formatted string.
 */
export const render = (template: string, context: TemplateContext): string => mustache.render(template, context);
