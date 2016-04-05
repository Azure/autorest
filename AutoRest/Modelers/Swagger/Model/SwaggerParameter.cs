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
        /// <returns>True if there are no validation errors, false otherwise.</returns>
        public override bool Validate(ValidationContext context)
        {
            var errorCount = context.ValidationErrors.Count;

            context.Direction = DataDirection.Request;

            base.Validate(context);

            switch (In)
            {
                case ParameterLocation.Body:
                    {
                        if (Schema == null)
                        {
                            context.LogError("Each body parameter must have a schema defined.");
                        }
                        if (Type != DataType.None || 
                            !string.IsNullOrEmpty(Format) || 
                            Items != null || 
                            CollectionFormat != Generator.ClientModel.CollectionFormat.None || 
                            !string.IsNullOrEmpty(Default) ||
                            !string.IsNullOrEmpty(Pattern)) 
                        {
                            context.LogError("A body parameter cannot have a type, format, or any other properties describing its type.");
                        }
                        break;
                    }
                case ParameterLocation.Header:
                    {
                        // Header parameters should have a client name explicitly defined.
                        object clientName = null;
                        if (!Extensions.TryGetValue("x-ms-client-name", out clientName) || !(clientName is string))
                        {
                            context.LogError("Each header parameter should have an explicit client name defined for improved code generation output quality.");
                        }
                        if (Schema != null)
                        {
                            context.LogError("Only body parameters can have a schema defined.");
                        }
                        break;
                    }
                default:
                    {
                        if (Schema != null)
                        {
                            context.LogError("Only body parameters can have a schema defined.");
                        }
                        break;
                    }
            }

            if (!string.IsNullOrEmpty(Reference))
            {
                ValidateReference(context);
            }

            if (Schema != null)
            {
                Schema.Validate(context);
            }

            context.Direction = DataDirection.None;

            return context.ValidationErrors.Count == errorCount;
        }

        private void ValidateReference(ValidationContext context)
        {
            if (Reference.StartsWith("#"))
            {
                var parts = Reference.Split('/');
                if (parts.Length == 3 && parts[1].Equals("parameters"))
                {
                    SwaggerParameter param = null;
                    if (!context.Parameters.TryGetValue(parts[2], out param))
                    {
                        context.LogError(string.Format("'{0}' was not found in the parameters section of the document.", parts[2]));
                    }
                }
            }
            // TOOD: figure out how to validate non-local references, they should already be available.
        }

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorParameter = priorVersion as SwaggerParameter;

            if (priorParameter == null)
            {
                throw new ArgumentNullException("priorVersion");
            }

            var errorCount = context.ValidationErrors.Count;

            context.Direction = DataDirection.Request;

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
                context.Direction = DataDirection.Request;
                Schema.Compare(priorParameter.Schema, context);
                context.Direction = DataDirection.None;
            }

            context.Direction = DataDirection.None;

            return context.ValidationErrors.Count == errorCount;
        }
    }
}