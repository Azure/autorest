// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Model.Utilities;
using AutoRest.Swagger.Validation.Core;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class PutRequestResponseValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2017";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "A PUT operation request body schema must be the same as the 200 response schema. Operation: {0}";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        // Verifies if a PUT operation request and response schemas match
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            var serviceDefinition = (ServiceDefinition)context.Root;
            var ops = ValidationUtilities.GetOperationsByRequestMethod("put", serviceDefinition);
            foreach (var op in ops)
            {
                if (op.Parameters?.Any() != true)
                {
                    continue;
                }

                // look for the request body schema in the operation parameters section as well as the global parameters section
                string reqBodySchema = null;
                if (op.Parameters.Where(p => p.In == ParameterLocation.Body).Any())
                {
                    reqBodySchema = op.Parameters.First(p => p.In == ParameterLocation.Body).Reference?.StripDefinitionPath();
                }
                else
                {
                    var opGlobalParams = op.Parameters.Where(p => serviceDefinition.Parameters.ContainsKey(p.Reference?.StripDefinitionPath()));
                    if (opGlobalParams.Any())
                    {
                        reqBodySchema = opGlobalParams.First(p => p.In == ParameterLocation.Body).Reference?.StripDefinitionPath();
                    }
                }
                // if no body parameters were found, skip, let some other validation handle an empty body put operation
                if (string.IsNullOrEmpty(reqBodySchema))
                {
                    continue;
                }

                // if no 200 response exists, flag violation
                if (op.Responses?.ContainsKey("200")!=true)
                {
                    yield return null;
                }
                // if definitions does not contain the schema referenced in a 200 response, flag violation
                if (!serviceDefinition.Definitions.ContainsKey(op.Responses["200"].Schema?.Reference?.StripDefinitionPath()))
                {
                    yield return null;
                }
                // if the 200 response schema does not match the request body parameter schema, flag violation
                if (op.Responses["200"].Schema.Reference.StripDefinitionPath() != reqBodySchema)
                {
                    yield return null;
                }
            }
        }
    }
}
