// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class BodyTopLevelProperties : TypedRule<Dictionary<string, Operation>>
    {

        private readonly Regex resourceRefRegEx = new Regex(@".+/Resource$", RegexOptions.IgnoreCase);
        private readonly string[] allowedTopLevelProperties = { "name", "type", "id", "location", "properties", "tags", "plan", "sku", "etag",
                                                                "managedBy", "identity"}; 
        /// <summary>
        /// This rule passes if the body parameter contains top level properties only from the allowed set: name, type,
        /// id, location, properties, tags, plan, sku, etag, managedBy, identity
        /// </summary>
        /// <param name="paths"></param>
        /// <returns></returns>
        public override bool IsValid( Dictionary<string, Operation> path, RuleContext context, out object[] formatParameters)
        {
            List<string> notAllowedProperties = new List<string>();
            foreach (string operation in path.Keys)
            {
                if ((operation.ToLower().Equals("get") ||
                    operation.ToLower().Equals("put") ||
                    operation.ToLower().Equals("patch")) && path[operation]?.Parameters != null)
                {
                    foreach (SwaggerParameter param in path[operation].Parameters)
                    {
                        if (param.In == ParameterLocation.Body)
                        {
                            if (param?.Schema?.Reference != null)
                            {
                                string defName = Extensions.StripDefinitionPath(param.Schema.Reference);
                                var definition = ((ServiceDefinition)context.Root).Definitions[defName];
                                if (definition?.AllOf != null && definition.Properties != null &&
                                    definition.AllOf.Select(s => s.Reference).Where(reference => resourceRefRegEx.IsMatch(reference)) != null)
                                {
                                    //Model is allOf Resource
                                    foreach (KeyValuePair<string, Schema> prop in definition.Properties)
                                    {
                                        if (!allowedTopLevelProperties.Contains(prop.Key.ToLower()))
                                        {
                                            notAllowedProperties.Add(defName + "/" + prop.Key);
                                        }
                                    }
                                }    
                            }
                            if (param?.Schema?.AllOf != null && param.Schema.Properties != null &&
                                param.Schema.AllOf.Select(s => s.Reference).Where(reference => resourceRefRegEx.IsMatch(reference)) != null)
                            {
                                //Model is allOf Resource
                                foreach (KeyValuePair<string, Schema> prop in param.Schema.Properties)
                                {
                                    if (!allowedTopLevelProperties.Contains(prop.Key.ToLower()))
                                    {
                                        notAllowedProperties.Add(path[operation].OperationId + ":" + prop.Key);
                                    }
                                }
                            }
                          }  
                        }
                    }
                }
            formatParameters = new[] { string.Join(", ", notAllowedProperties.ToArray()) };
            return (notAllowedProperties.Count() == 0);
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.AllowedTopLevelProperties;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Warning;

    }
}
