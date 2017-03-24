// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Core.Properties;

namespace AutoRest.Swagger.Validation
{
    public class LongRunningResponseValidation : LongRunningExtensionRule
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2005";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// An x-ms-long-running-operation extension passes this rule if the operation that this extension has a valid response defined.
        /// </summary>
        /// <param name="longRunning">long running extension object.</param>
        /// <param name="context">Rule context.</param>
        /// <returns><c>true</c> if operation has valid response code modeled, otherwise <c>false</c>.</returns>
        /// <remarks>This rule corresponds to M2005.</remarks>
        public override bool IsValid(object longRunning, RuleContext context) => IsValidResponseCodes(context);

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        public override string MessageTemplate => Resources.LongRunningResponseNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;
    }
}
