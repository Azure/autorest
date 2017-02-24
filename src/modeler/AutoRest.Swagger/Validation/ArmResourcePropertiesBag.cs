// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Validation;
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
        public override string Id => "M3019";

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

        private static readonly IEnumerable<string> ArmPropertiesBag = new List<string>()
                                                                        { "name", "id", "type", "location",
                                                                          "properties", "managedBy", "identity",
                                                                          "sku", "plan", "tags", "etag" };

        // Verifies if a tracked resource has a corresponding get operation
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            var armDefs = ValidationUtilities.GetArmResources((ServiceDefinition)context.Root);
            foreach (var armDef in armDefs)
            {
                var repeatedProps = armDef.Properties.Keys.Intersect(ArmPropertiesBag);
                if (!repeatedProps.Any())
                {
                    continue;
                }
                else
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, string.Join(", ", repeatedProps));
                }
            }
        }
    }
}


