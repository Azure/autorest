/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { Clone } from '../ref/yaml';
import { MergeOverwriteOrAppend } from '../source-map/merging';
import { CreatePerFilePlugin, PipelinePlugin } from './common';

function decorateSpecialProperties(o: any): void {
  if (o["implementation"]) {
    o["x-ms-implementation"] = o["implementation"];
    delete o["implementation"];
  }
  if (o["forward-to"]) {
    o["x-ms-forward-to"] = o["forward-to"];
    delete o["forward-to"];
  }
}

export function GetPlugin_ComponentModifier(): PipelinePlugin {
  return CreatePerFilePlugin(async config => async (fileIn, sink) => {
    const componentModifier = Clone((config.Raw as any).components);
    if (componentModifier) {
      const o = fileIn.ReadObject<any>();

      // schemas:
      //  merge-override semantics, but decorate new properties so they're not serialized
      const schemasSource = componentModifier.schemas || {};
      const schemasTarget = o.schemas = o.schemas || {};
      for (const schemaKey of Object.keys(schemasSource)) {
        const schemaSource = schemasSource[schemaKey];
        const schemaTarget = schemasTarget[schemaKey] || {};
        // decorate properties
        if (schemaSource.properties) {
          for (const propertyKey of Object.keys(schemaSource.properties)) {
            const propSource = schemaSource.properties[propertyKey]
            if (!schemaTarget.properties || !schemaTarget.properties[propertyKey]) {
              propSource["x-ms-nowire"] = true;
            }
            decorateSpecialProperties(propSource);
          }
        }

        schemasTarget[schemaKey] = MergeOverwriteOrAppend(schemaSource, schemaTarget);
      }

      // parameters:
      //  merge-override semantics
      const paramsSource = componentModifier.parameters || {};
      const paramsTarget = o.parameters = o.parameters || {};
      for (const paramKey of Object.keys(paramsSource)) {
        const paramSource = paramsSource[paramKey];
        const paramTarget = paramsTarget[paramKey] || {};
        paramsTarget[paramKey] = MergeOverwriteOrAppend(paramSource, paramTarget);
      }

      // operations:
      //  merge-override semantics based on operationId, but decorate operations so they're not targetting the wire
      const operationsSource = componentModifier.operations || [];
      const operationsTarget1 = o["paths"] = o["paths"] || {};
      const operationsTarget2 = o["x-ms-paths"] = o["x-ms-paths"] || {};
      const getOperationWithId = (operationId: string): { get: () => any, set: (x: any) => void } | null => {
        for (const path of [...Object.values(operationsTarget1), ...Object.values(operationsTarget2)]) {
          for (const method of Object.keys(path)) {
            if (path[method].operationId === operationId) {
              return { get: () => path[method], set: x => path[method] = x };
            }
          }
        }
        return null;
      };
      const getDummyPath = (): string => {
        let path = "/dummy?" + Object.keys(operationsTarget2).length;
        while (path in operationsTarget2) {
          path += "0";
        }
        return path;
      };
      for (const newOperation of operationsSource) {
        const operationId: string | null = newOperation.operationId || null;
        const existingOperation = operationId && getOperationWithId(operationId);

        decorateSpecialProperties(newOperation);

        if (existingOperation) {
          existingOperation.set(MergeOverwriteOrAppend(newOperation, existingOperation.get()));
        } else {
          newOperation["x-ms-nowire"] = true;
          operationsTarget2[getDummyPath()] = { get: newOperation };
        }
      }

      return await sink.WriteObject(fileIn.Description, o);
    }
    return fileIn;
  });
}