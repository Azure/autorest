// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.Logging;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;
using AutoRest.Core.Properties;

namespace AutoRest.Swagger.Validation
{
    public class DescriptionAndTitleMissing : DescriptionRequired<Dictionary<string, Schema>>
    {
        private static readonly string ModelTypeFormatter = "'{0}' model/property";

        /// <summary>
        /// The template message for this Rule.
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.MissingTitleDescription;

        /// <summary>
        /// What kind of open api document type this rule should be applied to
        /// </summary>
        public override ServiceDefinitionDocumentType ServiceDefinitionDocumentType => ServiceDefinitionDocumentType.ARM | ServiceDefinitionDocumentType.Default;

        /// <summary>
        /// The rule could be violated by a property of a model referenced by many jsons belonging to the same
        /// composed state, to reduce duplicate messages, run validation rule in composed state
        /// </summary>
        public override ServiceDefinitionDocumentState ValidationRuleMergeState => ServiceDefinitionDocumentState.Composed;

        /// <summary>
        /// Validates model for description and title property
        /// </summary>
        /// <param name="schema">Schema being validated</param>
        /// <param name="context">Rule context</param>
        /// <returns><c>true</c> if model contains description/title, <c>false</c> otherwise</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            foreach (KeyValuePair<string, Schema> definition in definitions)
            {
                if (string.IsNullOrWhiteSpace(definition.Value.Description) && string.IsNullOrWhiteSpace(definition.Value.Title))
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path.AppendProperty(definition.Key)), this, string.Format(ModelTypeFormatter, definition.Key));
                }
            }
        }
    }
}
