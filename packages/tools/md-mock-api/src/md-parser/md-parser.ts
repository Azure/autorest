import fs from "fs";
import * as commonmark from "commonmark";
import yaml from "js-yaml";
import { logger } from "../logger";
import {
  CommonDefinition,
  CommonRequestDefinition,
  CommonResponseDefinition,
  MockRouteDefinition,
  MockRouteDefinitionGroup,
  MockRouteRequestDefinition,
  MockRouteResponseDefinition,
} from "../models";
import { extractBodyDefinitionFromTreeNode, extractBodyRequirementFromTreeNode } from "./md-body-parser";
import { extractCodeBlockFromMarkdownNode, extractCodeBlockFromTreeNode, ExtractedCodeBlock } from "./md-code-block";
import { mapMarkdownTree } from "./md-mapper";
import { convertToTree, dumpMarkdownTree, MarkdownTreeNode } from "./md-tree";
import { cleanRender } from "./md-utils";

/**
 * Parse a markdown api definition file.
 * @param path path to the file.
 */
export const parseMardownFile = async (path: string): Promise<MockRouteDefinitionGroup> => {
  logger.debug(`Reading file ${[path]}`);
  const content = await fs.promises.readFile(path);
  return parseMardown(content.toString());
};

/**
 * Parse a markdown api definition.
 * @param content Markdown content to parse.
 */
export const parseMardown = async (content: string): Promise<MockRouteDefinitionGroup> => {
  const parser = new commonmark.Parser();
  const parsed = parser.parse(content);
  const tree = convertToTree(parsed);
  logger.debug(`Extracted structure\n${dumpMarkdownTree(tree)}`);
  const group = convertTreeToDefinitionGroup(tree);
  logger.debug(`Extracted group: ${JSON.stringify(group, null, 2)}`);
  return group;
};

const KnownHeading = {
  common: "Common",
  routes: "Routes",
  request: "Request",
  response: "Response",
  body: "Body",
};

const convertTreeToDefinitionGroup = (tree: MarkdownTreeNode): MockRouteDefinitionGroup => {
  const title = cleanRender(tree.heading);
  logger.debug(`Title for document is '${title}'`);

  const { common, routes } = mapMarkdownTree(["Root"], tree, {
    common: {
      type: "heading",
      name: KnownHeading.common,
      process: (x) => extractCommonFromTreeNode(x),
    },
    routes: {
      type: "heading",
      required: true,
      name: KnownHeading.routes,
      process: (x) => extractRoutesFromTreeNode(x),
    },
  });

  return {
    title,
    common,
    routes,
  };
};

const extractCommonFromTreeNode = (tree: MarkdownTreeNode): CommonDefinition => {
  const { request, response } = mapMarkdownTree(["Common"], tree, {
    request: {
      type: "heading",
      name: KnownHeading.request,
      process: (x) => extractYamlConfigFromTreeNode<CommonRequestDefinition>(x, "Common > Request"),
    },
    response: {
      type: "heading",
      name: KnownHeading.response,
      process: (x) => extractYamlConfigFromTreeNode<CommonResponseDefinition>(x, "Common > Response"),
    },
  });

  return {
    request,
    response,
  };
};

const extractYamlConfigFromTreeNode = <T>(node: MarkdownTreeNode, sectionName: string): T => {
  const code = extractCodeBlockFromTreeNode(node, sectionName);
  return convertCodeBlockToYaml(code, sectionName);
};

const extractYamlConfigFromMarkdownNode = <T>(node: commonmark.Node, sectionName: string): T => {
  const code = extractCodeBlockFromMarkdownNode(node, sectionName);
  return convertCodeBlockToYaml(code, sectionName);
};

const convertCodeBlockToYaml = <T>(code: ExtractedCodeBlock, sectionName: string) => {
  if (code.language !== "yaml") {
    throw new Error(
      `Expected code block under section ${sectionName} to be yaml. But was defined as '${code.language}'`,
    );
  }
  const result = yaml.load(code.content);

  if (result === undefined) {
    throw new Error(`Couldn't parse yaml: ${code.content}`);
  }
  return (result as unknown) as T;
};

const extractRoutesFromTreeNode = (node: MarkdownTreeNode): MockRouteDefinition[] => {
  const result = [];
  for (const child of node.children) {
    if (!("heading" in child)) {
      logger.warn("Unexpected node right under the routes section. Make sure to follow the required structure.");
      continue;
    }
    result.push(extractRouteFromTreeNode(child));
  }
  return result;
};

const extractRouteFromTreeNode = (node: MarkdownTreeNode): MockRouteDefinition => {
  const routeTitle = cleanRender(node.heading);
  logger.debug(`Found route '${routeTitle}'`);

  const { requestConfig, response } = mapMarkdownTree(["Routes", routeTitle], node, {
    requestConfig: {
      type: "heading",
      name: KnownHeading.request,
      process: (x) => extractRequestDefinitionFromTreeNode(x, routeTitle),
    },
    response: {
      type: "heading",
      name: KnownHeading.response,
      required: true,
      process: (x) => extractResponseDefinitionFromTreeNode(x, routeTitle),
    },
  });

  return {
    request: { ...extractRouteInfoFromTitle(routeTitle), ...requestConfig },
    response,
  };
};

/**
 * Extract the method and url from the route title in this format `GET /myurl`
 * @param title
 */
const extractRouteInfoFromTitle = (title: string): Pick<MockRouteRequestDefinition, "method" | "url"> => {
  const [method, url] = title.toLowerCase().split(" ");
  if (
    method !== "get" &&
    method !== "post" &&
    method !== "put" &&
    method !== "patch" &&
    method !== "head" &&
    method !== "delete"
  ) {
    throw new Error(`Unknown method type ${method} for  route '${title}'`);
  }
  return { method, url };
};

const extractRequestDefinitionFromTreeNode = (
  node: MarkdownTreeNode,
  routeTitle: string,
): Partial<MockRouteRequestDefinition> => {
  let result: Partial<MockRouteRequestDefinition> = {};

  const sectionName = [KnownHeading.routes, routeTitle, KnownHeading.request].join(" > ");
  for (const child of node.children) {
    if ("heading" in child) {
      const childTitle = cleanRender(child.heading);
      switch (childTitle) {
        case KnownHeading.body:
          result = { ...result, body: extractBodyRequirementFromTreeNode(child, sectionName) };
          break;
        default:
          throw new Error(`Unexpected heading '${childTitle}' under section ${sectionName}`);
      }
    } else {
      const config = extractYamlConfigFromMarkdownNode<Partial<MockRouteRequestDefinition>>(child, sectionName);
      result = { ...result, ...config };
    }
  }

  return result;
};

const extractResponseDefinitionFromTreeNode = (
  node: MarkdownTreeNode,
  routeTitle: string,
): MockRouteResponseDefinition => {
  let result: Partial<MockRouteResponseDefinition> = {};

  const sectionName = [KnownHeading.routes, routeTitle, KnownHeading.request].join(" > ");
  for (const child of node.children) {
    if ("heading" in child) {
      const childTitle = cleanRender(child.heading);
      switch (childTitle) {
        case KnownHeading.body:
          result = { ...result, body: extractBodyDefinitionFromTreeNode(child, sectionName) };
          break;
        default:
          throw new Error(`Unexpected heading '${childTitle}' under section ${sectionName}`);
      }
    } else {
      const config = extractYamlConfigFromMarkdownNode<MockRouteResponseDefinition>(child, sectionName);
      result = { ...result, ...config };
    }
  }
  assertProperty(result, "status", sectionName);
  return result as MockRouteResponseDefinition;
};

const assertProperty = <T, K extends keyof T>(
  value: T,
  key: K,
  sectionName: string,
): value is T & Required<Pick<T, K>> => {
  if (!value[key]) {
    throw new Error(`Section ${sectionName} is missing required property ${key}`);
  }
  return true;
};
