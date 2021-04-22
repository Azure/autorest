import { createCommonmarkProcessorPlugin } from "./commonmark";
import { createAllOfCleaner } from "./allof-cleaner";
import { createCommandPlugin } from "./command";

import { createComponentKeyRenamerPlugin } from "./component-key-renamer";
import { createComponentsCleanerPlugin } from "./components-cleaner";
import { createSwaggerToOpenApi3Plugin } from "./conversion";
import { createDeduplicatorPlugin } from "./deduplicator";
import { createArtifactEmitterPlugin } from "./emitter";
import { createEnumDeduplicator } from "./enum-deduplication";
import { createHelpPlugin } from "./help";
import {
  createIdentityPlugin,
  createIdentityResetPlugin,
  createNormalizeIdentityPlugin,
  createNullPlugin,
} from "./identity";
import { createOpenApiLoaderPlugin, createSwaggerLoaderPlugin } from "./loaders";
import { createMultiApiMergerPlugin } from "./merger";
import { createNewComposerPlugin } from "./new-composer";
import { createProfileFilterPlugin } from "./profile-filter";
import { createQuickCheckPlugin } from "./quick-check";
import { subsetSchemaDeduplicatorPlugin } from "./subset-schemas-deduplicator";
import {
  createImmediateTransformerPlugin,
  createTextTransformerPlugin,
  createTransformerPlugin,
  createGraphTransformerPlugin,
} from "./transformer";
import { createTreeShakerPlugin } from "./tree-shaker/tree-shaker";
import { createApiVersionParameterHandlerPlugin } from "./version-param-handler";
import { createJsonToYamlPlugin, createYamlToJsonPlugin } from "./yaml-and-json";
import { createOpenApiSchemaValidatorPlugin, createSwaggerSchemaValidatorPlugin } from "./schema-validation";
import { createOpenAPIStatsCollectorPlugin } from "./openapi-stats-collector";
import { QuickDataSource } from "@azure-tools/datastore";
import { createCSharpReflectApiVersionPlugin } from "./metadata-generation";
import { createComponentModifierPlugin } from "./component-modifier";
import { createSemanticValidationPlugin } from "./semantics-validation";

export const CORE_PLUGIN_MAP = {
  "help": createHelpPlugin(),
  "identity": createIdentityPlugin(),
  "null": createNullPlugin(),
  "reset-identity": createIdentityResetPlugin(),
  "normalize-identity": createNormalizeIdentityPlugin(),
  "loader-swagger": createSwaggerLoaderPlugin(),
  "loader-openapi": createOpenApiLoaderPlugin(),
  "openapi-stats-collector": createOpenAPIStatsCollectorPlugin(),
  "transform": createTransformerPlugin(),
  "text-transform": createTextTransformerPlugin(),
  "new-transform": createGraphTransformerPlugin(),
  "transform-immediate": createImmediateTransformerPlugin(),
  "compose": createNewComposerPlugin(),
  "schema-validator-openapi": createOpenApiSchemaValidatorPlugin(),
  "schema-validator-swagger": createSwaggerSchemaValidatorPlugin(),
  "semantic-validator": createSemanticValidationPlugin(),
  "openapi-document-converter": createSwaggerToOpenApi3Plugin(),
  "component-modifiers": createComponentModifierPlugin(),
  "yaml2jsonx": createYamlToJsonPlugin(),
  "jsonx2yaml": createJsonToYamlPlugin(),
  "reflect-api-versions-cs": createCSharpReflectApiVersionPlugin(),
  "commonmarker": createCommonmarkProcessorPlugin(),
  "profile-definition-emitter": createArtifactEmitterPlugin(),
  "emitter": createArtifactEmitterPlugin(),
  "configuration-emitter": createArtifactEmitterPlugin(
    async (context) =>
      new QuickDataSource([
        await context.DataStore.getDataSink().writeObject(
          "configuration",
          context.config.raw,
          ["fix-me-4"],
          "configuration",
        ),
      ]),
  ),
  "tree-shaker": createTreeShakerPlugin(),
  "enum-deduplicator": createEnumDeduplicator(),
  "quick-check": createQuickCheckPlugin(),
  "model-deduplicator": createDeduplicatorPlugin(),
  "subset-reducer": subsetSchemaDeduplicatorPlugin(),
  "multi-api-merger": createMultiApiMergerPlugin(),
  "components-cleaner": createComponentsCleanerPlugin(),
  "component-key-renamer": createComponentKeyRenamerPlugin(),
  "api-version-parameter-handler": createApiVersionParameterHandlerPlugin(),
  "profile-filter": createProfileFilterPlugin(),
  "allof-cleaner": createAllOfCleaner(),
  "command": createCommandPlugin(),
};
