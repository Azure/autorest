// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Validation.Core;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates the version of the swagger. API version must follow the date pattern
    /// yyyy-MM-dd and allowed prefixes are -preview, -alpha, -beta, -rc, -privatepreview.
    /// </summary>
    public class APIVersionPattern : TypedRule<string>
    {
        private static readonly Regex VersionRegex = new Regex(@"^(20\d{2})-(0[1-9]|1[0-2])-((0[1-9])|[12][0-9]|3[01])(-(preview|alpha|beta|rc|privatepreview))?$");

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3012";

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
        public override string MessageTemplate => Resources.APIVersionFormatIsNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        /// <summary>
        /// An <paramref name="version"/> fails this rule if it does not have the required format.
        /// </summary>
        /// <param name="version">Version to validate</param>
        /// <returns>true if the version is valid. false otherwise.</returns>
        public override bool IsValid(string version) => !string.IsNullOrEmpty(version) && VersionRegex.IsMatch(version);
    }


}
