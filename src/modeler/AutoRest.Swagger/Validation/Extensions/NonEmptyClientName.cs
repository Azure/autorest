// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class NonEmptyClientName : ExtensionRule
    {
        protected override string ExtensionName => "x-ms-client-name";

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2028";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        public override bool IsValid(object clientName)
        {
            var ext = clientName as Newtonsoft.Json.Linq.JContainer;
            if (ext != null && (ext["name"] == null || string.IsNullOrEmpty(ext["name"].ToString())))
            {
                return false;
            }
            else if (string.IsNullOrEmpty(clientName as string))
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.EmptyClientName;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;
    }
}
