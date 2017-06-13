// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class ArmResourcePropertiesBag : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R3019";

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
        public override string MessageTemplate => Resources.ArmPropertiesBagValidationMessage;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

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
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        private static readonly IEnumerable<string> ArmPropertiesBag = new List<string>()
                                                                        { "name", "id", "type", "location", "tag" };
        
        // Verifies whether ARM resource has the set of properties repeated in its property bag
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            var resModels = context.ResourceModels;
            var violatingModels = resModels.Where(res => definitions[res].Properties?.ContainsKey("properties") == true
                                                         && definitions[res].Properties["properties"]?.Properties?.Keys.Intersect(ArmPropertiesBag).Any() == true);
            foreach (var violatingModel in violatingModels)
            {
                var violatingProperties = definitions[violatingModel].Properties.Keys.Union(definitions[violatingModel].Properties["properties"].Properties.Keys).Intersect(ArmPropertiesBag);
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(violatingModel).AppendProperty("properties")), this, violatingModel, 
                                                   string.Join(", ", violatingProperties));
            }
        }
    }
}


