// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class ListOperationNamingWarning : TypedRule<Dictionary<string,Dictionary<string, Operation>>>
    {
        private readonly Regex ListRegex = new Regex(@".+_List([^_]*)$", RegexOptions.IgnoreCase);

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M1003";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string,Dictionary<string, Operation>> entity, RuleContext context)
        {
            // get all operation objects that are either of get or post type
            var serviceDefinition = (ServiceDefinition)context.Root;
            var listOperations = entity.Values.SelectMany(opDict=>opDict.Where(pair => pair.Key.ToLower().Equals("get") || pair.Key.ToLower().Equals("post")));
            foreach (var opPair in listOperations)
            {
                // if the operation id is already of the type _list we can skip this check
                if (ListRegex.IsMatch(opPair.Value.OperationId))
                {
                    continue;
                }

                if(ValidationUtilities.IsXmsPageableOrArrayResponseOperation(opPair.Value, serviceDefinition))
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, opPair.Value.OperationId);
                }
            }
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
        public override Category Severity => Category.Error;
    }
}




