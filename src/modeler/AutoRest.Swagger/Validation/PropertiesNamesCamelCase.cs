// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    /// <summary>
    /// Property names must be camelCase style
    /// </summary>
    public class PropertiesNamesCamelCase : TypedRule<Dictionary<string, Operation>>
    {

        private readonly Regex propNameRegEx = new Regex(@"^[a-z0-9]+([A-Z][a-z0-9]+)+|^[a-z0-9]+$|^[a-z0-9]+[A-Z]$");

        /// <summary>
        /// Id of the Rule.
        /// </summary>
        public override string Id => "M3016";

        /// <summary>
        /// Violation category of the Rule.
        /// </summary>
        public override ValidationCategory ValidationCategory => ValidationCategory.RPCViolation;

        /// <summary>;
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.PropertyNameCamelCase;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override Category Severity => Category.Error;

        ///// <summary>
        ///// Validates whether property names are camelCase.
        ///// </summary>
        public override IEnumerable<ValidationMessage> GetValidationMessages(Dictionary<string, Operation> path, RuleContext context)
        {
            List<string> badlyNamedProperties = new List<string>();
            foreach (string operation in path.Keys)
            {
                if (path[operation]?.Parameters != null)
                {
                    foreach (SwaggerParameter param in path[operation].Parameters)
                    {
                        if (param.In == ParameterLocation.Body)
                        {
                            if (param.Schema?.Properties != null)
                            {
                                badlyNamedProperties.AddRange(param.Schema.Properties.Select(s => s.Key).Where(propertyName => !propNameRegEx.IsMatch(propertyName)));
                            }
                        }
                        if (param?.Schema?.Reference != null)
                        {
                            string defName = Extensions.StripDefinitionPath(param.Schema.Reference);
                            var definition = ((ServiceDefinition)context.Root).Definitions[defName];
                            if (definition?.Properties != null)
                            {
                                var selectedProps = definition.Properties.Select(s => s.Key).Where(propertyName => !propNameRegEx.IsMatch(propertyName));
                                if (selectedProps != null)
                                {
                                    foreach (string prop in selectedProps)
                                    {
                                        badlyNamedProperties.Add(defName + "/" + prop);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            foreach (var prop in badlyNamedProperties)
            {
                yield return new ValidationMessage(new FileObjectPath(context.File, context.Path), this, prop, toCamelCase(prop.Split('/').Last()));
            }
        }


        private string toCamelCase(string prop)
        {
            StringBuilder sb = new StringBuilder(prop);
            if (sb.Length>0)
            {
                sb[0] = sb[0].ToString().ToLower()[0];
            }
            bool firstUpper = true;
            for (int i = 1; i < prop.Length; i++)
            {  
                if (char.IsUpper(sb[i]) && firstUpper){
                    firstUpper = false;
                }
                else if (char.IsUpper(sb[i]))
                {
                    sb[i] = sb[i].ToString().ToLower()[0];
                }
            }
            return sb.ToString();
        }
    }
}