// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;
using System;

namespace AutoRest.Swagger.Validation
{
    public class ResourceModelMustContainFixedProperties : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R3029";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.ResourceModelMustContainFixedProperties;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// The rule could be violated by a porperty of a model referenced by many jsons belonging to the same
        /// composed state, to reduce duplicate messages, run validation rule in composed state
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        /// <summary>
        /// Verifies if a tracked resource has a corresponding ListBySubscription operation
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            foreach (string key in definitions.Keys)
            {
                if (key.ToLower().Equals("resource", StringComparison.OrdinalIgnoreCase))
                {
                    Schema resourceSchema = definitions.GetValueOrNull(key);
                    if (resourceSchema == null || 
                        resourceSchema.Properties.Count != 5 ||
                        !this.validateSchemaProperty(resourceSchema, "id", true) ||
                        !this.validateSchemaProperty(resourceSchema, "name", true) ||
                        !this.validateSchemaProperty(resourceSchema, "type", true) ||
                        !this.validateSchemaProperty(resourceSchema, "location", false) ||
                        !this.validateSchemaProperty(resourceSchema, "tags", false))
                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(key)), this, key);
                }
            }
        }

        private bool validateSchemaProperty(Schema resourceSchema, string propertyName, bool checkForReadOnly)
        {
            Schema resultSchema = resourceSchema.Properties.GetValueOrNull(propertyName);
            if (resultSchema == null || (checkForReadOnly && !resultSchema.ReadOnly))
                return false;
            return true;
        }
    }
}
