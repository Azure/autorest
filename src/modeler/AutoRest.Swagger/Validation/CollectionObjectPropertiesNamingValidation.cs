// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class CollectionObjectPropertiesNamingValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        private readonly Regex ListRegex = new Regex(@".+_List([^_]*)$", RegexOptions.IgnoreCase);

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3008";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> entity, RuleContext context)
        {
            // get all operation objects that are either of get or post type
            ServiceDefinition serviceDefinition = (ServiceDefinition)context.Root;
            var listOperations = entity.Values.SelectMany(opDict => opDict.Where(pair => pair.Key.ToLower().Equals("get") || pair.Key.ToLower().Equals("post")));
            foreach (var opPair in listOperations)
            {
                // if the operation id is not of type _list* or does not return an array type, skip
                if (!ListRegex.IsMatch(opPair.Value.OperationId) || !ValidationUtilities.IsXmsPageableOperation(opPair.Value))
                {
                    continue;
                }
                
                string collType = opPair.Value.Responses["200"]?.Schema?.Reference?.StripDefinitionPath();
                // if no response type defined skip
                if (collType == null)
                {
                    continue;
                }

                var collTypeDef = serviceDefinition.Definitions[collType];
                // if collection object has 2 properties or less (x-ms-pageable objects can have the nextlink prop)
                // and the object does not have a property named "value", show the warning
                if ((collTypeDef.Properties?.Count <= 2) && collTypeDef.Properties.All(prop => !(prop.Key.ToLower().Equals("value") && prop.Value.Type == DataType.Array)))
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, collType, opPair.Value.OperationId);
                }
            }
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.CollectionObjectPropertiesNamingMessage;
        
        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;
    }
}