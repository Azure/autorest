// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Collections.Generic;
using Resources = Microsoft.Rest.Modeler.Swagger.Properties.Resources;
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

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorParameter = priorVersion as SwaggerParameter;

            if (priorParameter == null)
            {
                throw new ArgumentNullException("priorVersion");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            var errorCount = context.ValidationErrors.Count;

            context.Direction = DataDirection.Request;

            base.Compare(priorVersion, context);

            if (In != priorParameter.In)
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.ParameterInHasChanged2, priorParameter.In.ToString().ToLower(CultureInfo.CurrentCulture), In.ToString().ToLower(CultureInfo.CurrentCulture)));
            }

            if (IsConstant != priorParameter.IsConstant)
            {
                context.LogBreakingChange(Resources.ConstantStatusHasChanged);
            }

            if (Reference != null && !Reference.Equals(priorParameter.Reference))
            {
                context.LogBreakingChange(Resources.ReferenceRedirection);
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