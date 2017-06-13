// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class AvoidMsdnReferences : TypedRule<string>
    {
        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "R1010";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.SDKViolation;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM | ServiceDefinitionDocumentType.DataPlane;

        /// <summary>
        /// Whether the rule should be applied to the individual or composed context based on
        /// the corresponding .md file
        /// In most cases this should be composed
        /// This is because validation rules that run in individual mode will end up
        /// throwing multiple validation messages for the same violation if related model/property,etc 
        /// was referenced in multiple files
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Individual;
        
        private static readonly Regex MsdnRegex = new Regex(@"https?:\/\/msdn(?:.microsoft)?.com\/", RegexOptions.IgnoreCase);

        /// <summary>
        /// An <paramref name="entity"/> fails this rule if its description contains references to "msdn.microsoft.com".
        /// </summary>
        /// <param name="entity">The entity to validate</param>
        /// <returns></returns>
        public override bool IsValid(string entity) => string.IsNullOrEmpty(entity) || !MsdnRegex.IsMatch(entity);

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.MsdnReferencesDiscouraged;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

    }
}
