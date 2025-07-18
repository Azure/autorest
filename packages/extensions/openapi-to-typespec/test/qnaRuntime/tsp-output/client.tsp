import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using QnAMakerRuntimeClient;

@@clientLocation(RuntimeOperationGroup.generateAnswer, "Runtime");
@@clientLocation(RuntimeOperationGroup.train, "Runtime");
