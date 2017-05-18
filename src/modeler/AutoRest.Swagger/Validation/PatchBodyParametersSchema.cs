// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Properties;
using AutoRest.Core.Logging;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using System.Linq;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class PatchBodyParametersSchema : TypedRule<Dictionary<string, Schema>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2016";

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
        public override string MessageTemplate => "Properties of a PATCH request body must not be {0}. PATCH operation: '{1}' Model Definition: '{2}' Property: '{3}'";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        // Verifies if a tracked resource has a corresponding PATCH operation
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            ServiceDefinition serviceDefinition = (ServiceDefinition)context.Root;
            // enumerate all the PATCH operations
            IEnumerable<Operation> patchOperations = ValidationUtilities.GetOperationsByRequestMethod("patch", serviceDefinition);
            
            foreach (var op in patchOperations)
            {
                var reqModels = op.Parameters.Where(p => p.In == ParameterLocation.Body).Select(p => p.Schema?.Reference?.StripDefinitionPath()).Where(p=>!string.IsNullOrEmpty(p));
                foreach (var reqModel in reqModels)
                {

                    // select all models that have properties set to required
                    var reqProps = ValidationUtilities.EnumerateRequiredProperties(reqModel, definitions);
                    
                    // select all models that have properties with default values
                    var defValProps = ValidationUtilities.EnumerateDefaultValuedProperties(reqModel, definitions);

                    var modelHierarchy = ValidationUtilities.EnumerateModelHierarchy(reqModel, definitions);

                    foreach (var reqProp in reqProps)
                    {
                        var modelContainingReqProp = modelHierarchy.First(model => definitions[model].Required?.Contains(reqProp) == true);
                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(modelContainingReqProp).AppendProperty("required")), this, "required", op.OperationId, modelContainingReqProp, reqProp);
                    }
                    
                    foreach (var defValProp in defValProps)
                    {
                        var modelContainingDefValProp = modelHierarchy.First(model => definitions[model].Properties?.Contains(defValProp) == true);
                        yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(modelContainingDefValProp).AppendProperty("properties").AppendProperty(defValProp.Key)), this, "default-valued", op.OperationId, modelContainingDefValProp, defValProp.Key);
                    }
                    
                }
            }
            
        }
    }
}
