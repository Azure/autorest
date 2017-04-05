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
    public class PutResponseResourceValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "MBlah1";

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
        public override string MessageTemplate => Resources.PutOperationResourceResponseValidationMessage;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        // Verifies if a tracked resource has a corresponding PATCH operation
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context)
        {
            var serviceDefinition = (ServiceDefinition)context.Root;
            var ops = ValidationUtilities.GetOperationsByRequestMethod("put", serviceDefinition);
            var putRespModels = ops.Select(op => (op.Responses?.ContainsKey("200") != true) ? null : op.Responses["200"].Schema?.Reference?.StripDefinitionPath());
            putRespModels = putRespModels.Where(modelName => !string.IsNullOrEmpty(modelName));
            var xmsResModels = ValidationUtilities.GetXmsAzureResourceModels(serviceDefinition.Definitions);
            var violatingModels = putRespModels.Where(respModel => !ValidationUtilities.EnumerateModelHierarchy(respModel, serviceDefinition.Definitions).Intersect(xmsResModels).Any());
            foreach (var model in violatingModels)
            {
                var violatingOp = ops.Where(op => (op.Responses?.ContainsKey("200") == true) && op.Responses["200"].Schema.Reference.StripDefinitionPath() == model).First();
                var violatingPath = paths.Where(pathObj => pathObj.Value.Values.Where(op => op.OperationId == violatingOp.OperationId).Any()).First();
                var violatingOpVerb = violatingPath.Value.Keys.Where(key => key.EqualsIgnoreCase("put")).First();
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(violatingPath.Key).AppendProperty(violatingOpVerb).AppendProperty("operationId")), this, violatingOp.OperationId, model);
            }
        }
    }
}
