// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using Newtonsoft.Json;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Validation;
using System.Collections.Generic;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Describes a single operation parameter.
    /// https://github.com/wordnik/swagger-spec/blob/master/versions/2.0.md#parameterObject 
    /// </summary>
    [Serializable]
    [Rule(typeof(ParameterDescriptionRequired))]
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
        /// Compare a modified document node (this) to a previous one and look for breaking as well as non-breaking changes.
        /// </summary>
        /// <param name="context">The modified document context.</param>
        /// <param name="previous">The original document model.</param>
        /// <returns>A list of messages from the comparison.</returns>
        public override IEnumerable<ComparisonMessage> Compare(ComparisonContext context, SwaggerBase previous)
        {
            var priorParameter = previous as SwaggerParameter;

            if (priorParameter == null)
            {
                throw new ArgumentNullException("priorVersion");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            context.Direction = DataDirection.Request;

            base.Compare(context, previous);

            if (In != priorParameter.In)
            {
                context.LogBreakingChange(ComparisonMessages.ParameterInHasChanged, priorParameter.In.ToString().ToLower(CultureInfo.CurrentCulture), In.ToString().ToLower(CultureInfo.CurrentCulture));
            }

            if (this.IsConstant != priorParameter.IsConstant)
            {
                context.LogBreakingChange(ComparisonMessages.ConstantStatusHasChanged);
            }

            if (Reference != null && !Reference.Equals(priorParameter.Reference))
            {
                context.LogBreakingChange(ComparisonMessages.ReferenceRedirection);
            }

            if (Schema != null && priorParameter.Schema != null)
            {
                Schema.Compare(context, priorParameter.Schema);
            }

            context.Direction = DataDirection.None;

            return context.Messages;
        }
    }
}