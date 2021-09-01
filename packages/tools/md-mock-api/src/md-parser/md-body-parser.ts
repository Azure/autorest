import { MockBody, RequestBodyRequirement } from "../models";
import { cleanupBody } from "../utils";
import { extractCodeBlockFromTreeNode, Language } from "./md-code-block";
import { MarkdownTreeNode } from "./md-tree";

type SupportedBodyLanguage = Extract<Language, "json" | "xml">;

export const extractBodyRequirementFromTreeNode = (
  node: MarkdownTreeNode,
  fromSection: string,
): RequestBodyRequirement => {
  const sectionName = `${fromSection} > Body`;
  const code = extractCodeBlockFromTreeNode(node, sectionName);
  const language = validateSupportedLanguage(code.language, sectionName);

  const content = parseContent(language, code.content, sectionName);
  return {
    rawContent: code.content.trim(),
    content: content,
    matchType: content ? "object" : "exact",
    contentType: getContentTypeFromLanguage(language, sectionName),
  };
};

export const extractBodyDefinitionFromTreeNode = (node: MarkdownTreeNode, fromSection: string): MockBody => {
  const sectionName = `${fromSection} > Body`;
  const code = extractCodeBlockFromTreeNode(node, sectionName);
  const language = validateSupportedLanguage(code.language, sectionName);

  return {
    rawContent: cleanupBody(code.content),
    contentType: getContentTypeFromLanguage(language, sectionName),
  };
};

const validateSupportedLanguage = (language: Language, sectionName: string): SupportedBodyLanguage => {
  switch (language) {
    case "json":
    case "xml":
      return language;
    default:
      throw new Error(
        `Language ${language} used in section ${sectionName} is not known and can't be used for body content.`,
      );
  }
};

const parseContent = (
  language: SupportedBodyLanguage,
  rawContent: string,
  sectionName: string,
): unknown | undefined => {
  try {
    switch (language) {
      case "json":
        return JSON.parse(rawContent);
      case "xml":
        return undefined;
    }
  } catch (e: any) {
    throw new Error(`Failed to parse body defined in '${sectionName}'. Code is not valid '${language}': ${e.message}`);
  }
};

const langageContentTypes = {
  json: "application/json",
  xml: "application/xml",
};

export const getContentTypeFromLanguage = (language: SupportedBodyLanguage, sectionName: string): string => {
  return langageContentTypes[language];
};
