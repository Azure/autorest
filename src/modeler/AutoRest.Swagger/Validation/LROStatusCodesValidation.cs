// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using System.Linq;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class LROStatusCodesValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "blah";

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
        public override string MessageTemplate => "200/201 Responses of long running operations must have a schema definition for return type. OperationId: '{0}', Response code: '{1}'";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Verifies if a tracked resource has a corresponding ListBySubscription operation
        /// </summary>
        /// <param name="definitions"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            var serviceDefinition = (ServiceDefinition)context.Root;

            foreach (var path in paths)
            {
                var lroPutOps = path.Value.Where(val => val.Key.ToLower().Equals("put")).Select(val => val.Value);
                foreach (var op in lroPutOps)
                {
                    if (op.Responses == null)
                    {
                        // if put operation has no response model, let some other validation rule handle the violation
                        continue;
                    }
                    foreach (var resp in op.Responses)
                    {
                        if (resp.Key == "200" || resp.Key == "201")
                        {
                            var modelRef = resp.Value?.Schema?.Reference?? string.Empty;
                            if (!serviceDefinition.Definitions.ContainsKey(modelRef))
                            {
                                var violatingVerb = ValidationUtilities.GetOperationIdVerb(op.OperationId, path);
                                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(path.Key).AppendProperty(violatingVerb).AppendProperty("responses").AppendProperty(resp.Key)), 
                                    this, op.OperationId, resp.Key);

                            }
                        }

                    }
                }
            }
        }
    }
}
