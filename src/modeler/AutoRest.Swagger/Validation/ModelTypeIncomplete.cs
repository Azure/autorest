// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.Logging;
using AutoRest.Swagger.Validation.Core;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public class ModelTypeIncomplete : DescriptionRequired<Dictionary<string, Schema>>
    {
        private static readonly string ModelTypeFormatter = "'{0}' model/property";

        /// <summary>
        /// Validates model for description property
        /// </summary>
        /// <param name="schema">Schema being validated</param>
        /// <param name="context">Rule context</param>
        /// <returns><c>true</c> if model contains description, <c>false</c> otherwise</returns>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Schema> definitions, RuleContext context)
        {
            foreach (KeyValuePair<string, Schema> definition in definitions)
            {
                string key = definition.Key;
                Schema schema = definition.Value;
                if (string.IsNullOrWhiteSpace(schema.Description))
                {
                    yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, string.Format(ModelTypeFormatter, key));
                }
            }
        }
    }
}
