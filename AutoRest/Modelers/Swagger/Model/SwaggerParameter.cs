// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Collections.Generic;
using Newtonsoft.Json;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// Describes a single operation parameter.
    /// https://github.com/wordnik/swagger-spec/blob/master/versions/2.0.md#parameterObject
    /// </summary>
    [Serializable]
    public class SwaggerParameter : SwaggerObject
    {
        private bool _isRequired;
        public string Name { get; set; }

        public ParameterLocation In { get; set; }

        [JsonProperty(PropertyName = "required")]
        public override bool IsRequired
        {
            get { return (_isRequired) || In == ParameterLocation.Path; }
            set { _isRequired = value; }
        }

        [JsonIgnore]
        public bool IsConstant
        {
            get { return IsRequired && Enum != null && Enum.Count == 1; }
        }

        /// <summary>
        /// The schema defining the type used for the body parameter.
        /// </summary>
        public Schema Schema { get; set; }

        /// <summary>
        /// Validate the Swagger object against a number of object-specific validation rules.
        /// </summary>
        /// <param name="validationErrors">A list of error messages, filled in during processing.</param>
        /// <returns>True if there are no validation errors, false otherwise.</returns>
        public override bool Validate(List<LogEntry> validationErrors)
        {
            var errorCount = validationErrors.Count;
            base.Validate(validationErrors);

            switch (In)
            {
                case ParameterLocation.Body:
                    {
                        if (Schema == null)
                        {
                            validationErrors.Add(new LogEntry
                            {
                                Severity = LogEntrySeverity.Error,
                                Message = string.Format(CultureInfo.InvariantCulture, "'{0}' is a body parameter and must have a schema defined.", Name)
                            });
                        }
                        break;
                    }
                case ParameterLocation.Header:
                    {
                        // Header parameters should have a client name explicitly defined.
                        object clientName = null;
                        if (!Extensions.TryGetValue("x-ms-client-name", out clientName) || !(clientName is string))
                        {
                            validationErrors.Add(new LogEntry
                            {
                                Severity = LogEntrySeverity.Warning,
                                Message = string.Format(CultureInfo.InvariantCulture, "'{0}' is a header parameter and should have an explicit client name defined for improved code generation output quality.", Name)
                            });
                        }
                        if (Schema != null)
                        {
                            validationErrors.Add(new LogEntry
                            {
                                Severity = LogEntrySeverity.Error,
                                Message = string.Format(CultureInfo.InvariantCulture, "'{0}' is not a body parameter and must therefore not have a schema defined.", Name)
                            });
                        }
                        break;
                    }
                default:
                    {
                        if (Schema != null)
                        {
                            validationErrors.Add(new LogEntry
                            {
                                Severity = LogEntrySeverity.Error,
                                Message = string.Format(CultureInfo.InvariantCulture, "'{0}' is not a body parameter and must therefore not have a schema defined.", Name)
                            });
                        }
                        break;
                    }
            }

            if (Schema != null)
                Schema.Validate(validationErrors);
            return validationErrors.Count == errorCount;
        }

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorParameter = priorVersion as SwaggerParameter;

            if (priorParameter == null)
            {
                throw new ArgumentNullException("priorVersion");
            }

            var errorCount = context.ValidationErrors.Count;

            base.Compare(priorVersion, context);

            if (In != priorParameter.In)
            {
                context.LogBreakingChange(string.Format("how the parameter is passed has changed -- it used to be '{0}', now it is '{1}'", priorParameter.In.ToString().ToLowerInvariant(), In.ToString().ToLowerInvariant()));
            }

            if (IsConstant != priorParameter.IsConstant)
            {
                context.LogBreakingChange("The 'constant' status changed from the old version to the new");
            }

            if (Reference != null && !Reference.Equals(priorParameter.Reference))
            {
                context.LogBreakingChange("The $ref properties point to different models in the old and new versions");
            }

            if (Schema != null && priorParameter.Schema != null)
            {
                Schema.Compare(priorParameter.Schema, context);
            }

            return context.ValidationErrors.Count == errorCount;
        }
    }
}