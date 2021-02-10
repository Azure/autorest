/* eslint-disable @typescript-eslint/no-non-null-assertion */
import fs from "fs";
import path from "path";
import Parser from "tree-sitter";
import TypeScript from "tree-sitter-typescript/typescript";
import {
  CompareResult,
  FileDetails,
  prepareResult,
  compareItems,
  compareValue,
  MessageType,
  OrderedItem,
  compareStrings,
  compareText,
} from "../comparers";

const parser = new Parser();
parser.setLanguage(TypeScript);

export type ParameterDetails = {
  name: string;
  type: string;
  ordinal: number;
  isOptional: boolean;
};

export interface VariableDetails {
  name: string;
  type: string;
  value?: string;
}

export interface ModuleVariableDetails extends VariableDetails {
  isConst?: boolean;
  isExported: boolean;
}

export interface FieldDetails extends VariableDetails {
  visibility?: Visibility;
  isReadOnly?: boolean;
}

export interface GenericTypeParameterDetails extends OrderedItem {}

export interface FunctionDetails {
  name: string;
  body: string;
  returnType: string;
  genericTypes: GenericTypeParameterDetails[];
  parameters: ParameterDetails[];
}

export type Visibility = "public" | "private" | "protected";

export interface MethodDetails extends FunctionDetails {
  visibility: Visibility;
}

export type InterfaceDetails = {
  name: string;
  interfaces?: string[];
  methods: MethodDetails[];
  fields: FieldDetails[];
  isExported: boolean;
};

export type ClassDetails = {
  name: string;
  baseClass?: string;
  interfaces?: string[];
  methods: MethodDetails[];
  fields: FieldDetails[];
  isExported: boolean;
};

export type TypeDetails = {
  name: string;
  type: string;
  isExported: boolean;
};

export type SourceDetails = {
  classes: ClassDetails[];
  interfaces: InterfaceDetails[];
  types: TypeDetails[];
  variables: ModuleVariableDetails[];
  functions: FunctionDetails[];
};

export function parseFile(filePath: string): Parser.Tree {
  const contents = fs.readFileSync(filePath).toString();
  return parser.parse(contents);
}

function extractField(fieldNode: Parser.SyntaxNode): FieldDetails {
  const { typeNode, valueNode } = fieldNode as any;
  const accessibilityNode = fieldNode.namedChildren.find((n) => n.type === "accessibility_modifier");
  const readOnlyNode = fieldNode.namedChildren.find((n) => n.type === "readonly");

  return {
    name: (fieldNode as any).nameNode.text,
    type: typeNode ? typeNode.children[1].text : "any",
    value: valueNode ? valueNode.text : undefined,
    visibility: accessibilityNode ? (accessibilityNode.text as Visibility) : "private",
    isReadOnly: readOnlyNode !== undefined,
  };
}

function extractParameter(parameterNode: Parser.SyntaxNode, ordinal: number): ParameterDetails {
  const [nameNode, typeNode] = parameterNode.namedChildren;

  return {
    name: nameNode.text,
    type: typeNode ? typeNode.children[1].text : "any",
    ordinal,
    isOptional: parameterNode.type === "optional_parameter",
  };
}

function extractGenericParameter(genericParamNode: Parser.SyntaxNode, ordinal: number): GenericTypeParameterDetails {
  return {
    name: genericParamNode.namedChildren[0].text,
    ordinal,
  };
}

function extractFunction(functionNode: Parser.SyntaxNode): FunctionDetails {
  const returnTypeNode = (functionNode as any).returnTypeNode;
  const parameterNodes = (functionNode as any).parametersNode.namedChildren;
  const genericNodes = (functionNode as any).typeParametersNode;

  return {
    name: (functionNode as any).nameNode.text,
    body: (functionNode as any).bodyNode.text,
    genericTypes: genericNodes
      ? genericNodes.namedChildren.map((p: any, i: number) => extractGenericParameter(p, i))
      : [],
    returnType: returnTypeNode ? returnTypeNode.children[1].text : "any",
    parameters: parameterNodes.map((p: any, i: any) => extractParameter(p, i)),
  };
}

function extractMethod(methodNode: Parser.SyntaxNode): MethodDetails {
  const accessibilityNode = methodNode.namedChildren.find((n) => n.type === "accessibility_modifier");

  return {
    ...extractFunction(methodNode),
    visibility: accessibilityNode ? (accessibilityNode.text as Visibility) : "public",
  };
}

function isExported(node: Parser.SyntaxNode): boolean {
  return node.parent!.type === "export_statement";
}

function extractImplements(node: Parser.SyntaxNode): string[] | undefined {
  const implementsNode: Parser.SyntaxNode = (node as any).namedChildren.find(
    (n: any) => n.type === "implements_clause",
  );

  return implementsNode ? implementsNode.namedChildren.map((i) => i.text) : undefined;
}

function extractExtends(node: Parser.SyntaxNode): string[] | undefined {
  const extendsNode: Parser.SyntaxNode = (node as any).namedChildren.find((n: any) => n.type === "extends_clause");

  return extendsNode ? extendsNode.namedChildren.map((i) => i.text) : undefined;
}

function extractClass(classNode: Parser.SyntaxNode): ClassDetails {
  const classBody: Parser.SyntaxNode = (classNode as any).bodyNode;
  const heritageNode: Parser.SyntaxNode = (classNode as any).namedChildren.find(
    (n: any) => n.type === "class_heritage",
  );
  const baseClass = heritageNode ? (extractExtends(heritageNode) || [])[0] : undefined;
  const interfaces = heritageNode ? extractImplements(heritageNode) : undefined;

  return {
    name: (classNode as any).nameNode.text,
    methods: classBody.namedChildren.filter((n) => n.type === "method_definition").map(extractMethod),
    fields: classBody.namedChildren.filter((n) => n.type === "public_field_definition").map(extractField),
    isExported: isExported(classNode),
    ...(baseClass ? { baseClass } : undefined),
    ...(interfaces ? { interfaces } : undefined),
  };
}

function extractInterface(interfaceNode: Parser.SyntaxNode): InterfaceDetails {
  const interfaceBody: Parser.SyntaxNode = (interfaceNode as any).bodyNode;
  const interfaces = extractExtends(interfaceNode);

  return {
    name: (interfaceNode as any).nameNode.text,
    methods: interfaceBody.namedChildren.filter((n) => n.type === "method_definition").map(extractMethod),
    fields: interfaceBody.namedChildren.filter((n) => n.type === "public_field_definition").map(extractField),
    isExported: isExported(interfaceNode),
    ...(interfaces ? { interfaces } : undefined),
  };
}

function extractTypeAlias(typeAliasNode: Parser.SyntaxNode): TypeDetails {
  const typeNode = (typeAliasNode as any).valueNode;

  return {
    name: (typeAliasNode as any).nameNode.text,
    type: typeNode.text,
    isExported: isExported(typeAliasNode),
  };
}

function extractVariable(variableNode: Parser.SyntaxNode): ModuleVariableDetails {
  const typeNode = (variableNode as any).typeNode;
  const valueNode = (variableNode as any).valueNode;

  return {
    name: (variableNode as any).nameNode.text,
    type: typeNode ? typeNode.children[1].text : "any",
    value: valueNode ? valueNode.text : undefined,
    // There isn't a named child for 'const' so look for its type
    isConst: variableNode.parent!.children[0].type === "const",
    // variable_declarator is wrapped in a lexical_declaration
    isExported: isExported(variableNode.parent!),
  };
}

export function isModuleScopeVariable(variableNode: Parser.SyntaxNode): boolean {
  const grandparent = variableNode.parent && variableNode.parent.parent;
  return Boolean(grandparent && (grandparent.type === "export_statement" || grandparent.type === "program"));
}

export function extractSourceDetails(parseTree: Parser.Tree): SourceDetails {
  return {
    classes: parseTree.rootNode.descendantsOfType("class_declaration").map(extractClass),
    interfaces: parseTree.rootNode.descendantsOfType("interface_declaration").map(extractInterface),
    types: parseTree.rootNode.descendantsOfType("type_alias_declaration").map(extractTypeAlias),
    variables: parseTree.rootNode
      .descendantsOfType("variable_declarator")
      .filter(isModuleScopeVariable)
      .map(extractVariable),
    functions: parseTree.rootNode.descendantsOfType("function_declaration").map(extractFunction),
  };
}

export function compareParameter(oldParameter: ParameterDetails, newParameter: ParameterDetails): CompareResult {
  return prepareResult(oldParameter.name, MessageType.Changed, [
    compareValue("Type", oldParameter.type, newParameter.type),
    compareValue("Optional", oldParameter.isOptional, newParameter.isOptional),
  ]);
}

export function compareFunction(
  oldFunction: FunctionDetails,
  newFunction: FunctionDetails,
  extraResults?: CompareResult[],
): CompareResult {
  return prepareResult(oldFunction.name, MessageType.Changed, [
    compareItems(
      "Generic Parameters",
      MessageType.Outline,
      oldFunction.genericTypes,
      newFunction.genericTypes,
      (t) => undefined, // There's nothing to compare other than existence and order
      true,
    ),
    compareItems(
      "Parameters",
      MessageType.Outline,
      oldFunction.parameters,
      newFunction.parameters,
      compareParameter,
      true,
    ),
    compareValue("Return Type", oldFunction.returnType, newFunction.returnType),
    ...(extraResults || []),
    compareText("Body", oldFunction.body, newFunction.body),
  ]);
}

export function compareMethod(oldMethod: MethodDetails, newMethod: MethodDetails): CompareResult {
  return compareFunction(oldMethod, newMethod, [
    compareValue("Visibility", oldMethod.visibility, newMethod.visibility),
  ]);
}

export function compareField(oldField: FieldDetails, newField: FieldDetails): CompareResult {
  return prepareResult(oldField.name, MessageType.Changed, [
    compareValue("Type", oldField.type, newField.type),
    compareText("Value", oldField.value, newField.value),
    compareValue("Visibility", oldField.visibility, newField.visibility),
    compareValue("Read Only", oldField.isReadOnly, newField.isReadOnly),
  ]);
}

export function compareVariable(oldVariable: ModuleVariableDetails, newVariable: ModuleVariableDetails): CompareResult {
  return prepareResult(oldVariable.name, MessageType.Changed, [
    compareValue("Type", oldVariable.type, newVariable.type),
    compareText("Value", oldVariable.value, newVariable.value),
    compareValue("Exported", oldVariable.isExported, newVariable.isExported),
    compareValue("Constant", oldVariable.isConst, newVariable.isConst),
  ]);
}

export function compareClass(oldClass: ClassDetails, newClass: ClassDetails): CompareResult {
  return prepareResult(oldClass.name, MessageType.Changed, [
    compareValue("Exported", oldClass.isExported, newClass.isExported),
    compareValue("Base Class", oldClass.baseClass, newClass.baseClass),
    compareStrings("Interfaces", oldClass.interfaces, newClass.interfaces),
    compareItems("Methods", MessageType.Outline, oldClass.methods, newClass.methods, compareMethod),
    compareItems("Fields", MessageType.Outline, oldClass.fields, newClass.fields, compareField),
  ]);
}

export function compareInterface(oldInterface: InterfaceDetails, newInterface: InterfaceDetails): CompareResult {
  return prepareResult(oldInterface.name, MessageType.Changed, [
    compareValue("Exported", oldInterface.isExported, newInterface.isExported),
    compareStrings("Base Interfaces", oldInterface.interfaces, newInterface.interfaces),
    compareItems("Methods", MessageType.Outline, oldInterface.methods, newInterface.methods, compareMethod),
    compareItems("Fields", MessageType.Outline, oldInterface.fields, newInterface.fields, compareField),
  ]);
}

export function compareFile(oldFile: FileDetails, newFile: FileDetails): CompareResult {
  const oldSource = extractSourceDetails(parseFile(path.resolve(oldFile.basePath, oldFile.name)));
  const newSource = extractSourceDetails(parseFile(path.resolve(newFile.basePath, newFile.name)));

  return prepareResult(oldFile.name, MessageType.Changed, [
    compareItems("Classes", MessageType.Outline, oldSource.classes, newSource.classes, compareClass),
    compareItems("Interfaces", MessageType.Outline, oldSource.interfaces, newSource.interfaces, compareInterface),
    compareItems("Functions", MessageType.Outline, oldSource.functions, newSource.functions, compareFunction),
    compareItems("Variables", MessageType.Outline, oldSource.variables, newSource.variables, compareVariable),
  ]);
}
