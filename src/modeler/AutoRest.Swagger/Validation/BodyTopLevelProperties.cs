// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

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
        public override string Id => "M3006";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;


        /// <summary>
        /// This rule passes if the model definition contains top level properties only from the allowed set: name, type,
        /// id, location, properties, tags, plan, sku, etag, managedBy, identity
        /// </summary>
        /// <param name="definitions">The model definitions</param>
        /// <param name="context">The context object</param>
        /// <returns>validation messages</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            var resModels = context.ResourceModels;
            var violatingModels = resModels.Where(resModel => definitions[resModel].Properties?.Keys.Except(AllowedTopLevelProperties).Any() == true);
            foreach (var violatingModel in violatingModels)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(violatingModel).AppendProperty("properties")), this, 
                    violatingModel, string.Join(",", definitions[violatingModel].Properties.Keys.Except(AllowedTopLevelProperties)));
            }
        }
        
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

    }
}
