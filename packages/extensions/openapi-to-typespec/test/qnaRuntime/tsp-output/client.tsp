import "./main.tsp";

using QnAMakerRuntimeClient;

@@clientLocation(RuntimeOperationGroup.generateAnswer, "Runtime");
@@clientLocation(RuntimeOperationGroup.train, "Runtime");
