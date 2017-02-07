// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model.Utilities;
using System.Collections.Generic;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;
using System.Linq;

namespace AutoRest.Swagger.Validation
{
    public class TrackedResourcePatchOperationValidation : TypedRule<Dictionary<string, Schema>>
    {
        private readonly Regex exemptedNames = new Regex(@"^(RESOURCE|TRACKEDRESOURCE)$", RegexOptions.IgnoreCase);


        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.TrackedResourceIsNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Validation fails if the tracked resource does not have a corresponding 
        /// "patch" operation in the service definition
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <param name="formatParameters">The noun to be put in the failure message</param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Schema> definitions, RuleContext context)
        {
            List<Operation> patchOperations = ValidationUtilities.GetOperationsByRequestMethod("patch", (ServiceDefinition)context.Root);
            foreach (KeyValuePair<string, Schema> definition in definitions)
            {
                if (!exemptedNames.IsMatch(definition.Key) && ValidationUtilities.IsTrackedResource(definition.Value, definitions))
                {
                    if (!patchOperations.Any(op => op.Parameters.Any(p => p.Schema.AllOf.First() == definition.Value || p.Reference.ToString() == definition.Value)))
                    {
                        // if no patch operation takes in the current tracked resource as a request parameter, 
                        // the tracked resource does not have a corresponding patch operation, grounds to call
                        // the swagger invalid!
                        return false;
                    }
                }
            }
        }
    }



namespace AutoRest.Swagger.Validation
{
    public class TrackedResourceValidation : TypedRule<Dictionary<string, Schema>>
    {
        private readonly Regex listByRgRegEx = new Regex(@".+_ListByResourceGroup$", RegexOptions.IgnoreCase);
        private readonly Regex listBySidRegEx = new Regex(@".+_(List|ListBySubscriptionId|ListBySubscription|ListBySubscriptions)$", RegexOptions.IgnoreCase);
        private readonly Regex propertiesRegEx = new Regex(@"^(TYPE|LOCATION|TAGS)$", RegexOptions.IgnoreCase);

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.TrackedResourceIsNotValid;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

        /// <summary>
        /// Validation fails iof tracked resource fails to meet one of the four required criteria.
        /// </summary>
        /// <param name="definitions">Operation Definition to validate</param>
        /// <param name="formatParameters">The noun to be put in the failure message</param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Schema> definitions, RuleContext context, out object[] formatParameters)
        {
            List<Operation> getOperations = this.GetOperationsByRequestMethod("get", (ServiceDefinition)context.Root);

            foreach (KeyValuePair<string, Schema> definition in definitions)
            {
                if (!exemptedNames.IsMatch(definition.Key) && ValidationUtilities.IsTrackedResource(definition.Value, definitions))
                {
                    bool getCheck = getOperations.Any(operation =>
                        operation.Responses.Any(response =>
                            response.Key.Equals("200") &&
                            response.Value.Schema != null &&
                            response.Value.Schema.Reference != null &&
                            response.Value.Schema.Reference.EndsWith("/" + definition.Key)
                        )
                     );
                    if (!getCheck)
                    {
                        formatParameters = new object[2];
                        formatParameters[0] = definition.Key;
                        formatParameters[1] = 1;
                        return false;
                    }

                    bool listByResourceGroupCheck = this.listByXCheck(getOperations, listByRgRegEx, definition.Key, definitions);
                    if (!listByResourceGroupCheck)
                    {
                        formatParameters = new object[2];
                        formatParameters[0] = definition.Key;
                        formatParameters[1] = 2;
                        return false;
                    }

                    bool listBySubscriptionIdCheck = this.listByXCheck(getOperations, listBySidRegEx, definition.Key, definitions);
                    if (!listBySubscriptionIdCheck)
                    {
                        formatParameters = new object[2];
                        formatParameters[0] = definition.Key;
                        formatParameters[1] = 3;
                        return false;
                    }

                    bool schemaResult = this.HandleSchema(definition.Value, definitions);
                    if (!schemaResult)
                    {
                        formatParameters = new object[2];
                        formatParameters[0] = definition.Key;
                        formatParameters[1] = 4;
                        return false;
                    }
                }
            }

            formatParameters = new object[0];
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

                bool schemaResult = this.HandleSchema(property.Value, definitions);
                if (!schemaResult)
                {
                    return false;
                }
            }

            return true;
        }

        private bool HandleSchema(Schema schema, Dictionary<string, Schema> definitions)
        {
            if (schema.Reference != null)
            {
                Schema resultSchema = Schema.FindReferencedSchema(schema.Reference, definitions);
                bool schemaResult = this.HandleSchema(resultSchema, definitions);
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

        private bool listByXCheck(List<Operation> getOperations, Regex regEx, string definitionKey, Dictionary<string, Schema> definitions)
        {
            return getOperations.Any(operation =>
                       regEx.IsMatch(operation.OperationId) &&
                       operation.Extensions != null &&
                       operation.Extensions.Any(extension => extension.Key.ToLower().Equals("x-ms-pageable")) &&
                       operation.Responses.Any(
                           response => response.Key.Equals("200") &&
                           response.Value.Schema != null && this.IsArrayOf(response.Value.Schema.Reference, definitionKey, definitions))
                    );
        }

        private bool IsArrayOf(string reference, string referenceToMatch, Dictionary<string, Schema> definitions)
        {
            Schema schema = Schema.FindReferencedSchema(reference, definitions);
            return schema.Properties.Any(property => property.Value.Type == DataType.Array && property.Value.Items != null && property.Value.Items.Reference.EndsWith("/" + referenceToMatch));
        }

        
    }
}
