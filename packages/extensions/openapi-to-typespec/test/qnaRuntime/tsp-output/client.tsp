import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using QnAMakerRuntimeClient;

@@clientLocation(RuntimeOperationGroup.generateAnswer, "Runtime");
@@clientName(RuntimeOperationGroup.generateAnswer, "GenerateAnswer");
@@clientLocation(RuntimeOperationGroup.train, "Runtime");
