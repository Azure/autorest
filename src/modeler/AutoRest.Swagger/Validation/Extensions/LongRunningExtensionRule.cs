// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.Logging;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public abstract class LongRunningExtensionRule : ExtensionRule
    {
        protected override string ExtensionName => "x-ms-long-running-operation";

        protected static bool IsValidResponseCodes(RuleContext context)
        {
            Dictionary<string, OperationResponse> responses = context?.GetFirstAncestor<Operation>()?.Responses;
            var method = context?.Parent?.Parent?.Key;
            var resolver = new SchemaResolver(context?.GetServiceDefinition());

            if (method == null)
            {
                return false;
            }

            bool isPutPatchResponseCodesValid = true;
            bool isPostResponseCodesValid = true;
            bool isDeleteResponseCodesValid = true;

            switch (method.ToLower())
            {
                case "put":
                case "patch":
                    isPutPatchResponseCodesValid = IsPutPatchResponseCodesValid(responses, resolver);
                    break;
                case "post":
                    isPostResponseCodesValid = IsPostResponseCodesValid(responses, resolver);
                    break;
                case "delete":
                    isDeleteResponseCodesValid = IsDeleteResponseCodesValid(responses, resolver);
                    break;
                default:
                    break;

            }

            return isPutPatchResponseCodesValid && isPostResponseCodesValid && isDeleteResponseCodesValid;
        }

        public abstract override string MessageTemplate { get; }

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public abstract override Category Severity { get; }

        /// <summary>
        /// Validate that Put or Patch long running operations must have valid terminal status code 200 or 201.
        /// </summary>
        /// <param name="responses">Dictionary of responses for the operation.</param>
        /// <param name="resolver">The schema reolver.</param>
        /// <returns><c>true</c> if at least one valid terminal status code availabe, otherwise <c>false</c>.</returns>
        private static bool IsPutPatchResponseCodesValid(Dictionary<string, OperationResponse> responses, SchemaResolver resolver)
        {
            OperationResponse response200 = responses?.GetValueOrNull("200");
            OperationResponse response201 = responses?.GetValueOrNull("201");

            if (response200 == null && response201 == null)
            {
                return false;
            }

            if (resolver.Unwrap(response200.Schema) == null && resolver.Unwrap(response201.Schema) == null)
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Validate that Post long running operations must have valid terminal status code 200, 201 or 204.
        /// </summary>
        /// <param name="responses">Dictionary of responses for the operation.</param>
        /// <param name="resolver">The schema reolver.</param>
        /// <returns><c>true</c> if at least one valid terminal status code availabe, otherwise <c>false</c>.</returns>
        private static bool IsPostResponseCodesValid(Dictionary<string, OperationResponse> responses, SchemaResolver resolver)
        {
            if (!IsPutPatchResponseCodesValid(responses, resolver))
            {
                OperationResponse response204 = responses?.GetValueOrNull("204");

                if (response204 == null)
                {
                    return false;
                }

                if (resolver.Unwrap(response204.Schema) == null)
                {
                    return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Validate that Delete long running operations must have valid terminal status code 200 or 204.
        /// </summary>
        /// <param name="responses">Dictionary of responses for the operation.</param>
        /// <param name="resolver">The schema reolver.</param>
        /// <returns><c>true</c> if at least one valid terminal status code availabe, otherwise <c>false</c>.</returns>
        private static bool IsDeleteResponseCodesValid(Dictionary<string, OperationResponse> responses, SchemaResolver resolver)
        {
            OperationResponse response200 = responses?.GetValueOrNull("200");
            OperationResponse response204 = responses?.GetValueOrNull("204");

            if (response200 == null && response204 == null)
            {
                return false;
            }

            if (resolver.Unwrap(response200.Schema) == null && resolver.Unwrap(response204.Schema) == null)
            {
                return false;
            }

            return true;
        }
    }
}
