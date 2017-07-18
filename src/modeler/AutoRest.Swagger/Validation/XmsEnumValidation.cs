// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using System.Linq;
using AutoRest.Swagger.Model.Utilities;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates if the x-ms-enum extension has been set for enum types
    /// </summary>
    public class XmsEnumValidation : TypedRule<Dictionary<string, Schema>>
    {
        
        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "The enum types should have x-ms-enum type extension set with appropriate options. Property name: {0}";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R2018";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM | ServiceDefinitionDocumentType.DataPlane;

        /// <summary>
        /// The rule could be violated by a porperty of a model referenced by many jsons belonging to the same
        /// composed state, to reduce duplicate messages, run validation rule in composed state
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            var violatingModels = definitions.Where(defPair=>defPair.Value.Properties?.Values.Any(schema => schema.Enum != null)??false);
            foreach (var modelPair in violatingModels)
            {
                var violatingProps = modelPair.Value.Properties.Where(prop => prop.Value.Enum != null && (!prop.Value.Extensions?.ContainsKey("x-ms-enum")??false));
                foreach (var prop in violatingProps)
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(modelPair.Key).AppendProperty("properties").AppendProperty(prop.Key)), this, prop.Key);
                }
            }
        }
    }
}
