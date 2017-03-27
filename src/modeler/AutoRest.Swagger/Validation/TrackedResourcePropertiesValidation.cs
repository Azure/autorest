// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using System.Linq;
using AutoRest.Swagger.Validation.Core;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class TrackedResourcePropertiesValidation : TypedRule<Dictionary<string, Schema>>
    {
        private readonly Regex propertiesRegEx = new Regex(@"^(TYPE|LOCATION|TAGS)$", RegexOptions.IgnoreCase);

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
        public override string MessageTemplate => Resources.TrackedResourcePropertiesValidation;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        public override bool IsValid(Dictionary<string, Schema> definitions, RuleContext context, out object[] formatParameters)
        {
            // Retrieve the list of TrackedResources
            IEnumerable<string> trackedResources = context.TrackedResourceModels;

            foreach (string trackedResource in trackedResources)
            {
                bool schemaResult = this.CheckSchemaForProperties(trackedResource, definitions);
                if (!schemaResult)
                {
                    formatParameters = new object[1];
                    formatParameters[0] = trackedResource;
                    return false;
                }
            }

            formatParameters = new object[0];
            return true;
        }

        private bool CheckSchemaForProperties(string schemaName, Dictionary<string, Schema> definitions)
        {
            Schema schema = definitions.GetValueOrNull(schemaName);
            return this.CheckSchemaForProperties(schema, definitions);
        }

        private bool CheckSchemaForProperties(Schema schema, Dictionary<string, Schema> definitions)
        {
            if (schema.Reference != null)
            {
                Schema resultSchema = Schema.FindReferencedSchema(schema.Reference, definitions);
                bool schemaResult = this.CheckSchemaForProperties(resultSchema, definitions);
                if (!schemaResult)
                {
                    return false;
                }
            }

            if (schema.Properties != null)
            {
                bool propertiesResult = this.HandleProperties(schema.Properties, definitions);
                if (!propertiesResult)
                {
                    return false;
                }
            }

            return true;
        }

        private bool HandleProperties(Dictionary<string, Schema> properties, Dictionary<string, Schema> definitions)
        {
            foreach (KeyValuePair<string, Schema> property in properties)
            {
                if (propertiesRegEx.IsMatch(property.Key))
                {
                    return false;
                }

                bool schemaResult = this.CheckSchemaForProperties(property.Value, definitions);
                if (!schemaResult)
                {
                    return false;
                }
            }

            return true;
        }
    }
}
