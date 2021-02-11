/* eslint-disable @typescript-eslint/no-non-null-assertion */
import fs from "fs";
import path from "path";
import Parser from "tree-sitter";
import Python from "tree-sitter-python";
import {
  CompareResult,
  FileDetails,
  prepareResult,
  compareItems,
  MessageType,
  compareText,
  NamedItem,
} from "../comparers";

interface ParameterDetails {
  name: string;
  type?: string;
  defaultValue?: string;
}

interface MethodDetails {
  name: string;
  body: string;
  returnType?: string;
  parameters: ParameterDetails[];
}

interface AssignmentDetails {
  name: string;
  value: string;
}

interface ClassDetails {
  name: string;
  superclasses: SuperclassDetails[];
  methods: MethodDetails[];
  assignments: AssignmentDetails[];
}

export interface SuperclassDetails extends NamedItem {}

export interface SourceDetails {
  classes: ClassDetails[];
}

export function extractParameter(paramNode: Parser.SyntaxNode): ParameterDetails {
  const nameNode = (paramNode as any).nameNode;
  const typeNode = (paramNode as any).typeNode;
  const valueNode = (paramNode as any).valueNode;

  return {
    name: nameNode ? nameNode.text : paramNode.text,
    type: typeNode?.text,
    defaultValue: valueNode?.text,
  };
}

export function extractMethod(methodNode: Parser.SyntaxNode): MethodDetails {
  const bodyNode = methodNode.namedChildren.find((node) => node.type === "block");
  const returnTypeNode = (methodNode as any).returnTypeNode;
  const parameterNodes = (methodNode as any).parametersNode.namedChildren.filter(
    // Comments in parameter lists are being included here, skip them
    (p: any) => !p.text.startsWith("#"),
  );

  return {
    name: (methodNode as any).nameNode.text,
    returnType: returnTypeNode ? returnTypeNode.text : undefined,
    body: bodyNode!.text,
    parameters: parameterNodes.map(extractParameter),
  };
}

export function compareParameter(oldParameter: ParameterDetails, newParameter: ParameterDetails): CompareResult {
  return prepareResult(oldParameter.name, MessageType.Changed, [
    compareText("Type", oldParameter.type, newParameter.type),
    compareText("Default Value", oldParameter.defaultValue, newParameter.defaultValue),
  ]);
}

export function compareMethod(oldMethod: MethodDetails, newMethod: MethodDetails): CompareResult {
  return prepareResult(oldMethod.name, MessageType.Changed, [
    compareItems("Parameters", MessageType.Outline, oldMethod.parameters, newMethod.parameters, compareParameter, true),
    compareText("Body", oldMethod.body, newMethod.body),
    compareText("Return Type", oldMethod.returnType, newMethod.returnType),
  ]);
}

export function extractAssignment(expressionNode: Parser.SyntaxNode): AssignmentDetails {
  const assignmentNode = expressionNode.namedChildren[0];
  const [leftSideNode, rightSideNode] = assignmentNode.namedChildren;

  return {
    name: leftSideNode.text,
    value: rightSideNode.text,
  };
}

export function compareAssignment(oldAssignment: AssignmentDetails, newAssignment: AssignmentDetails): CompareResult {
  return prepareResult(oldAssignment.name, MessageType.Changed, [
    compareText("Value", oldAssignment.value, newAssignment.value),
  ]);
}

export function extractClass(classNode: Parser.SyntaxNode): ClassDetails {
  const bodyNode = classNode.namedChildren.find((node) => node.type === "block");
  const superclasses = (classNode as any).superclassesNode;

  return {
    name: (classNode as any).nameNode.text,
    superclasses: superclasses
      ? superclasses.namedChildren.map((s: any) => {
          return {
            name: s.text,
          };
        })
      : [],
    methods: bodyNode!.namedChildren.filter((node) => node.type === "function_definition").map(extractMethod),
    assignments: bodyNode!.namedChildren
      .filter((node) => node.type === "expression_statement" && node.namedChildren[0].type === "assignment")
      .map(extractAssignment),
  };
}

export function compareClass(oldClass: ClassDetails, newClass: ClassDetails): CompareResult {
  return prepareResult(oldClass.name, MessageType.Changed, [
    compareItems(
      "Superclasses",
      MessageType.Outline,
      oldClass.superclasses,
      newClass.superclasses,
      (t) => undefined, // There's nothing to compare other than existence
    ),
    compareItems("Methods", MessageType.Outline, oldClass.methods, newClass.methods, compareMethod),
    compareItems("Fields", MessageType.Outline, oldClass.assignments, newClass.assignments, compareAssignment),
  ]);
}

export function extractSourceDetails(parseTree: Parser.Tree): SourceDetails {
  return {
    classes: parseTree.rootNode.descendantsOfType("class_definition").map(extractClass),
  };
}

const parser = new Parser();
parser.setLanguage(Python);

export function parseFile(filePath: string): Parser.Tree {
  const contents = fs.readFileSync(filePath).toString().replace(/\r\n/g, "\n");
  return parser.parse(contents);
}

export function compareFile(oldFile: FileDetails, newFile: FileDetails): CompareResult {
  const oldSource = extractSourceDetails(parseFile(path.resolve(oldFile.basePath, oldFile.name)));
  const newSource = extractSourceDetails(parseFile(path.resolve(newFile.basePath, newFile.name)));

  return prepareResult(oldFile.name, MessageType.Changed, [
    compareItems("Classes", MessageType.Outline, oldSource.classes, newSource.classes, compareClass),
  ]);
}
