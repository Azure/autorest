// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Core.Validation;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Validates the SKU Model. A Sku model must have name property. 
    /// It can also have tier, size, family, capacity as optional properties.
    /// </summary>
    public class SkuModelValidation : TypedRule<Dictionary<string, Schema>>
    {
        private readonly Regex propertiesRegEx = new Regex(@"^(NAME|TIER|SIZE|FAMILY|CAPACITY)$", RegexOptions.IgnoreCase);

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.SkuModelIsNotValid;

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M2057";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Validates Sku Model
        /// </summary>
        /// <param name="definitions">to be validated</param>
        /// <returns>true if valid.false otherwise</returns>
        public override bool IsValid(Dictionary<string, Schema> definitions)
        {
            foreach(KeyValuePair<string, Schema> definition in definitions)
            {
                if(definition.Key.EqualsIgnoreCase("sku"))
                {
                    Schema schema = definition.Value;
                    if (schema.Properties == null)
                        return false;

                    bool hasName = schema.Properties.Any(property =>
                        property.Key.EqualsIgnoreCase("name") &&
                        (property.Value.Type == Model.DataType.String || (property.Value.Type == null && evaluateIf(property.Value.Reference, definitions, Model.DataType.String))));

                    if (!hasName)
                        return false;

                    if (!schema.Properties.All(property => propertiesRegEx.IsMatch(property.Key)))
                        return false;
                }
            }

            return true;
        }

        /// <summary>
        /// Evaluates if the reference is of the provided data type.
        /// </summary>
        /// <param name="reference">reference to evaluate</param>
        /// <param name="definitions">definition list</param>
        /// <param name="dataType">Datatype value to evaluate</param>
        /// <returns>true if the reference is of the provided data type. False otherwise.</returns>
        private bool evaluateIf(string reference, Dictionary<string, Schema> definitions, Model.DataType dataType)
        {
            if (reference == null)
            {
                return false;
            }

            string definitionName = reference.Substring(reference.LastIndexOf('/') + 1).Trim();
            Schema schema = definitions.GetValueOrNull(definitionName);
            if (schema == null)
            {
                return false;
            }

            if (schema.Type == dataType || (schema.Type == null && schema.Reference != null && evaluateIf(schema.Reference, definitions, dataType)))
            {
                return true;
            }

            return false;
        }
    }
}
