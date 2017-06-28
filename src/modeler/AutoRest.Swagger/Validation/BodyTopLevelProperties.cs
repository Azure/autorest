// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class BodyTopLevelProperties : TypedRule<Dictionary<string, Schema>>
    {

        private static readonly IEnumerable<string> AllowedTopLevelProperties = new List<string>()
            { "name", "type", "id", "location", "properties", "tags", "plan", "sku", "etag",
              "managedBy", "identity", "kind"};

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R3006";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// The rule could be violated by a model referenced by many jsons belonging to the same
        /// composed state, to reduce duplicate messages, run validation rule in composed state
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.AllowedTopLevelProperties;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.ServiceImpactingChanges;

        /// <summary>
        /// This rule passes if the model definition contains top level properties only from the allowed set: name, type,
        /// id, location, properties, tags, plan, sku, etag, managedBy, identity
        /// </summary>
        /// <param name="definitions">The model definitions</param>
        /// <param name="context">The context object</param>
        /// <returns>validation messages</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            foreach(string resourceModel in context.ResourceModels)
            {
                IEnumerable<KeyValuePair<string, Schema>> topLevelProperties = ValidationUtilities.EnumerateProperties(resourceModel, definitions);
                IEnumerable<KeyValuePair<string, Schema>> violatingProperties = topLevelProperties.Where(topLevelProperty => !AllowedTopLevelProperties.Contains(topLevelProperty.Key));

                if (violatingProperties != null && violatingProperties.Any())
                {
                    List<string> list = new List<string>();
                    foreach (KeyValuePair<string, Schema> property in violatingProperties)
                    {
                        list.Add(property.Key);
                    }

                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(resourceModel).AppendProperty("properties")), this,
                    resourceModel, string.Join(",", list));
                }
            }
        }
    }
}
