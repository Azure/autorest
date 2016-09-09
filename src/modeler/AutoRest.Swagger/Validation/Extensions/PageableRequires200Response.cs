// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Validation;

namespace AutoRest.Swagger.Validation
{
    public class PageableRequires200Response : PageableExtensionRule
    {
        /// <summary>
        /// An x-ms-pageable extension passes this rule if the operation that this extension is defined on has a 200
        /// response defined
        /// </summary>
        /// <param name="pageable"></param>
        /// <param name="context"></param>
        /// <param name="formatParameters"></param>
        /// <returns></returns>
        public override bool IsValid(object pageable, RuleContext context) => Get200ResponseSchema(context) != null;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "A response for the 200 HTTP status code must be defined to use x-ms-pageable";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;
    }
}
