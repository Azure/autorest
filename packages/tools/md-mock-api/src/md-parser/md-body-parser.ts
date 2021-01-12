import { RequestBodyRequirement } from "../models";
import { extractCodeBlockFromTreeNode, Language } from "./md-code-block";
import { MarkdownTreeNode } from "./md-tree";

export const extractBodyRequirementFromTreeNode = (
  node: MarkdownTreeNode,
  fromSection: string,
): RequestBodyRequirement => {
  const sectionName = `${fromSection} > Body`;
  const code = extractCodeBlockFromTreeNode(node, sectionName);
  return {
    rawContent: code.content.trim(),
    contentType: getContentTypeFromLanguage(code.language, sectionName),
    matchType: "exact",
  };
};

const langageContentTypes = {
  json: "application/json",
  xml: "application/xml",
  yaml: undefined,
};

export const getContentTypeFromLanguage = (language: Language, sectionName: string): string => {
  const contentType = langageContentTypes[language];

  if (!contentType) {
    throw new Error(
      `Language ${language} used in section ${sectionName} is not known and can't be used for body content.`,
    );
  }
  return contentType;
};
