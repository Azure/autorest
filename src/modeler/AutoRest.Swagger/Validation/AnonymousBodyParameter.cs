﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class AnonymousBodyParameter : TypedRule<SwaggerParameter>
    {
        private static AvoidAnonymousTypes AnonymousTypesRule = new AvoidAnonymousTypes();

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2024";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.AnonymousTypesDiscouraged;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;

        /// <summary>
        /// An entity fails this rule if it has a schema, and that schema is an anonymous type
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(SwaggerParameter entity) =>
            entity?.Schema == null || AnonymousTypesRule.IsValid(entity.Schema);


    }
}