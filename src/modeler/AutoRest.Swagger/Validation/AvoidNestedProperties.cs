// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using System.Collections.Generic;

namespace AutoRest.Swagger.Validation
{
    public class AvoidNestedProperties : TypedRule<Schema>
    {
        private static readonly string ClientFlattenExtensionName = "x-ms-client-flatten";


        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2001";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// An <paramref name="entity" /> fails this rule if it 
        /// Intentionally ignore the value assigned to the extension
        /// If it has been set to false, we assume the author has
        /// explicitly chosen to avoid flattening
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(Schema schema, RuleContext context)
            => context.Key != "properties" || IsClientFlattenUsed(schema.Extensions);

        private static bool IsClientFlattenUsed(Dictionary<string, object> extensions)
            => extensions.ContainsKey(ClientFlattenExtensionName)
            && extensions[ClientFlattenExtensionName] is bool;

        /// <summary>
        ///     The template message for this Rule.
        /// </summary>
        /// <remarks>
        ///     This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Consider using x-ms-client-flatten to provide a better end user experience";

        /// <summary>
        ///     The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM | ServiceDefinitionDocumentType.DataPlane;

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;
    }
}