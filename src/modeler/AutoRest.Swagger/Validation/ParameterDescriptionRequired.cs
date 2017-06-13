// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Swagger.Model;
using AutoRest.Swagger.Validation.Core;

namespace AutoRest.Swagger.Validation
{
    public class ParameterDescriptionRequired : DescriptionRequired<SwaggerParameter>
    {
        private static readonly string ParameterTypeFormatter = "'{0}' parameter";

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
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        /// <summary>
        /// This rule fails if the description is null and the reference is null (since the reference could have a description)
        /// </summary>
        /// <param name="entity">Entity being validated</param>
        /// <param name="context">Rule context</param>
        /// <param name="formatParameters">formatted parameters</param>
        /// <returns><c>true</c> if entity contains description, <c>false</c> otherwise</returns>
        public override bool IsValid(SwaggerParameter entity, RuleContext context, out object[] formatParameters)
        {
            formatParameters = new string[] { string.Format(ParameterTypeFormatter, entity.Name) };
            return !string.IsNullOrWhiteSpace(entity.Description) || !string.IsNullOrWhiteSpace(entity.Reference);
        }
    }
}
