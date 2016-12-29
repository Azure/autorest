// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class PutGetPatchResponseValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.PutGetPatchResponseInvalid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// An <paramref name="operationDefinition"/> fails this rule if delete operation has a body.
        /// </summary>
        /// <param name="operationDefinition">Operation Definition to validate</param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            foreach(KeyValuePair<string, Dictionary<string, Operation>> pathCombination in paths)
            {
                Dictionary<string, Operation> operations = pathCombination.Value;
                if (operations.Count < 2)
                {
                    continue;
                }

                List<string> responseSchemaReference = new List<string>();

                foreach (KeyValuePair<string, Operation> operation in operations)
                {
                    if (operation.Key.ToLower().Equals("put") || operation.Key.ToLower().Equals("get") || operation.Key.ToLower().Equals("patch"))
                    {
                        Dictionary<string, OperationResponse> responses = operation.Value.Responses;
                        if(responses != null && responses.Count > 0)
                        {
                            foreach(KeyValuePair<string, OperationResponse> response in responses)
                            {
                                if(response.Value != null && response.Value.Schema != null && response.Value.Schema.Reference != null)
                                    responseSchemaReference.Add(response.Value.Schema.Reference);
                            }                            
                        }
                    }
                }

                if (responseSchemaReference.Distinct().Count() > 1)
                {
                    return false;
                }                    
            }            
            return true;
        }
    }
}
