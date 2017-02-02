// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class ListOperationNamingWarning : TypedRule<Dictionary<string,Dictionary<string, Operation>>>
    {
        private readonly string XmsPageable = "x-ms-pageable";
        private readonly Regex regex = new Regex(@".+_List(\w*)$", RegexOptions.IgnoreCase);
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string,Dictionary<string, Operation>> entity, RuleContext context)
        {
            // get all operation objects that are either of get or post type
            var serviceDefinition = (ServiceDefinition)context.Root;
            var listingOperations = entity.Values.SelectMany(opDict=>opDict.Where(pair => pair.Key.Equals("get") || pair.Key.Equals("post")));
            foreach (var opPair in listingOperations)
            {
                // if the operation id is already of the type _list we can skip this check
                if (regex.IsMatch(opPair.Value.OperationId)) continue;

                string opName = string.Empty;
                if((opName = GetXmsNullableOrArrayResponseOperation(opPair.Value, serviceDefinition))!=string.Empty)
                {
                    yield return new ValidationMessage(context.Path, this, opName);
                }
            }
        }

        // if the operation is xmsnullable type, it must be named a list operation
        // if the operation has response type 200 that returns an object which has an array of some type
        // we should mark it as a list operation
        private string GetXmsNullableOrArrayResponseOperation(Operation op, ServiceDefinition entity)
        {
            if (op.Extensions.ContainsKey(XmsPageable) && op.Extensions[XmsPageable] != null)  return string.Empty;

            if (!op.Responses.ContainsKey("200")) return string.Empty;

            if (!(op.Responses["200"]?.Schema?.Reference?.Equals(string.Empty) ?? true))
            {
                var modelLink = op.Responses["200"].Schema.Reference;
                if (entity.Definitions[modelLink.StripDefinitionPath()].Properties.Values.First(type => type.Type == DataType.Array) != null)
                {
                    return op.OperationId;
                }
            }
            return string.Empty;
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Operation {0} returns an array or is x-ms-pageable and should be named as *_list";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;
    }
}




