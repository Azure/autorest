// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Swagger.Model.Utilities;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates if the Operations API has been implemented
    /// </summary>
    public class OperationsAPIImplementationValidation : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3023";

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
        public override string MessageTemplate => Resources.OperationsAPINotImplemented;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// What kind of change implementing this rule can cause.
        /// </summary>
        public override ValidationChangesImpact ValidationChangesImpact => ValidationChangesImpact.SDKImpactingChanges;

        /// <summary>
        /// Represents Service Definition Document Type 
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        /// <summary>
        /// Represents Service Definition Document Merge state
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM;

        /// <summary>
        /// Validates if the Operations API has been implemented
        /// </summary>
        /// <param name="paths">API paths</param>
        /// <returns>true if the operations API has been implemented. false otherwise.</returns>
        public override bool IsValid(Dictionary<string, Dictionary<string, Operation>> paths, RuleContext context, out object[] formatParameters)
        {
            string[] operationPathsEndingWithOperations = paths.Keys.Where(x => x.Trim().ToLower().EndsWith("/operations")).ToArray();
            IEnumerable<string> resourceProviders = ValidationUtilities.GetResourceProviders(paths);

            // We'll check for only one RP in the swagger as other rules can validate having many RPs in one swagger
            string resourceProvider = resourceProviders?.ToList().Count > 0 ? resourceProviders.First() : null;
            string operationApiPath = string.Format("/providers/{0}/operations", resourceProvider);

            formatParameters = new object[] { };
            foreach (string operationPath in operationPathsEndingWithOperations)
            {
                if (operationPath.EndsWith(operationApiPath))
                {
                    return true;
                }
            }

            formatParameters = new string[] { operationApiPath };
            return false;
        }
    }
}
