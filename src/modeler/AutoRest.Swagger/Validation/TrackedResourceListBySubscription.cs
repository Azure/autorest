// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class TrackedResourceListBySubscription : TypedRule<Dictionary<string, Schema>>
    {
        private static readonly Regex listBySidRegEx = new Regex(@".+_(List|ListBySubscriptionId|ListBySubscription|ListBySubscriptions)$", RegexOptions.IgnoreCase);

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3027";

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
        public override string MessageTemplate => Resources.TrackedResourceListBySubscriptionsOperationMissing;

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
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            // Retrieve the list of TrackedResources
            IEnumerable<string> parentTrackedResources = context.ParentTrackedResourceModels;

            // Retrieve the list of getOperations
            IEnumerable<Operation> getOperations = ValidationUtilities.GetOperationsByRequestMethod("get", context.Root);

            foreach (string trackedResource in parentTrackedResources)
            {
                bool listBySubscriptionsCheck = ValidationUtilities.ListByXCheck(getOperations, listBySidRegEx, trackedResource, definitions);

                if (!listBySubscriptionsCheck)
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(trackedResource)), this, trackedResource);
                }
            }
        }
    }
}
