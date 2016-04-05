// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Collections.Generic;
using System.Globalization;
using Newtonsoft.Json;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Modeler.Swagger.Properties;
using Microsoft.Rest.Generator.Logging;
using System.Text.RegularExpressions;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// Describes a single operation determining with this object is mandatory.
    /// https://github.com/wordnik/swagger-spec/blob/master/versions/2.0.md#parameterObject
    /// </summary>
    [Serializable]
    public abstract class SwaggerObject : SwaggerBase
    {
        public virtual bool IsRequired { get; set; }

        /// <summary>
        /// The type of the parameter.
        /// </summary>
        public virtual DataType? Type { get; set; }

        /// <summary>
        /// The extending format for the previously mentioned type.
        /// </summary>
        public virtual string Format { get; set; }

        /// <summary>
        /// Describes the type of items in the array.
        /// </summary>
        public virtual Schema Items { get; set; }

        [JsonProperty(PropertyName = "$ref")]
        public string Reference { get; set; }

        /// <summary>
        /// Describes the type of additional properties in the data type.
        /// </summary>
        public virtual Schema AdditionalProperties { get; set; }

        public virtual string Description { get; set; }

        /// <summary>
        /// Determines the format of the array if type array is used.
        /// </summary>
        public virtual CollectionFormat CollectionFormat { get; set; }

        /// <summary>
        /// Sets a default value to the parameter.
        /// </summary>
        public virtual string Default { get; set; }

        public virtual string MultipleOf { get; set; }

        public virtual string Maximum { get; set; }

        public virtual bool ExclusiveMaximum { get; set; }

        public virtual string Minimum { get; set; }

        public virtual bool ExclusiveMinimum { get; set; }

        public virtual string MaxLength { get; set; }

        public virtual string MinLength { get; set; }

        public virtual string Pattern { get; set; }

        public virtual string MaxItems { get; set; }

        public virtual string MinItems { get; set; }

        public virtual bool UniqueItems { get; set; }

        public virtual IList<string> Enum { get; set; }

        public ObjectBuilder GetBuilder(SwaggerModeler swaggerSpecBuilder)
        {
            if (this is SwaggerParameter)
            {
                return new ParameterBuilder(this as SwaggerParameter, swaggerSpecBuilder);
            }
            if (this is Schema)
            {
                return new SchemaBuilder(this as Schema, swaggerSpecBuilder);
            }
            return new ObjectBuilder(this, swaggerSpecBuilder);
        }

        public PrimaryType ToType()
        {
            switch (Type)
            {
                case DataType.String:
                    if (string.Equals("date", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.Date);
                    }
                    if (string.Equals("date-time", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.DateTime);
                    }
                    if (string.Equals("date-time-rfc1123", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.DateTimeRfc1123);
                    }
                    if (string.Equals("byte", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.ByteArray);
                    }
                    if (string.Equals("duration", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.TimeSpan);
                    }
                    if (string.Equals("uuid", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.Uuid);
                    }
                    if (string.Equals("base64url", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.Base64Url);
                    }
                    return new PrimaryType(KnownPrimaryType.String);
                case DataType.Number:
                    if (string.Equals("decimal", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.Decimal);
                    }
                    return new PrimaryType(KnownPrimaryType.Double);
                case DataType.Integer:
                    if (string.Equals("int64", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.Long);
                    }
                    return new PrimaryType(KnownPrimaryType.Int);
                case DataType.Boolean:
                    return new PrimaryType(KnownPrimaryType.Boolean);
                case DataType.Object:
                case DataType.Array:
                case null:
                    return new PrimaryType(KnownPrimaryType.Object);
                case DataType.File:
                    return new PrimaryType(KnownPrimaryType.Stream);
                default:
                    throw new NotImplementedException(
                        string.Format(CultureInfo.InvariantCulture, 
                           Resources.InvalidTypeInSwaggerSchema,
                            Type));
            }
        }

        public override bool Validate(ValidationContext context)
        {
            var errorCount = context.ValidationErrors.Count;

            base.Validate(context);

            ValidateConstraints(context);

            return context.ValidationErrors.Count == errorCount;
        }

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var prior = priorVersion as SwaggerObject;

            if (prior == null)
            {
                throw new ArgumentNullException("priorVersion");
            }

            var errorCount = context.ValidationErrors.Count;

            base.Compare(priorVersion, context);

            if (Reference != null && !Reference.Equals(prior.Reference))
            {
                context.LogBreakingChange("The '$ref' property points to different models in the old and new versions");
            }

            if (IsRequired != prior.IsRequired)
            {
                context.LogBreakingChange("The 'required' status changed from the old version to the new");
            }
            
            // Are the types the same?

            if (prior.Type.HasValue != Type.HasValue || (Type.HasValue && prior.Type.Value != Type.Value))
            {
                context.LogBreakingChange("The new version has a different type than the previous one");
            }

            // What about the formats?

            CompareFormats(prior, context);

            CompareItems(prior, context);

            if (Default != null && !Default.Equals(prior.Default) || (Default == null && !string.IsNullOrEmpty(prior.Default)))
            {
                context.LogBreakingChange("The new version has a different default value than the previous one");
            }

            if (Type.HasValue && Type.Value == DataType.Array && prior.CollectionFormat != CollectionFormat)
            {
                context.LogBreakingChange("The new version has a different array collection format than the previous one");
            }

            // Additional properties

            if (prior.AdditionalProperties == null && AdditionalProperties != null)
            {
                context.LogBreakingChange("The new version adds an 'additionalProperties' element.");
            }
            else if (prior.AdditionalProperties != null && AdditionalProperties == null)
            {
                context.LogBreakingChange("The new version removes the 'additionalProperties' element.");
            }
            else if (AdditionalProperties != null)
            {
                context.PushTitle(context.Title + "/AdditionalProperties");
                AdditionalProperties.Compare(prior.AdditionalProperties, context);
                context.PopTitle();
            }

            // Was an enum value removed?

            if (prior.Enum != null)
            {
                if (this.Enum == null)
                {
                    context.LogBreakingChange("The new version does not specify a list of valid values.");
                }
                else
                {
                    foreach (var e in prior.Enum)
                    {
                        if (!this.Enum.Contains(e))
                        {
                            context.LogBreakingChange(string.Format("The new version does not include '{0}' in its list of valid values.", e));

                        }
                    }
                }
            }
            else if (this.Enum != null)
            {
                context.LogBreakingChange("The new version places constraints on valid values while the old doesn't.");
            }

            return context.ValidationErrors.Count == errorCount;
        }

        protected void CompareFormats(SwaggerObject prior, ValidationContext context)
        {
            if (prior.Format == null && Format != null || prior.Format != null && Format == null)
            {
                context.LogBreakingChange("The new version has a different format than the previous one");
            }
        }
        
        private void ValidateConstraints(ValidationContext context)
        {
            double numberValue;
            long integerValue = 0;

            if (Maximum != null && !double.TryParse(Maximum, out numberValue))
            {
                context.LogError(string.Format("'{0}' is not a valid value for the 'maximum' property. It must be a number.", Maximum));
            }
            if (Minimum != null && !double.TryParse(Minimum, out numberValue))
            {
                context.LogError(string.Format("'{0}' is not a valid value for the 'minimum' property. It must be a number.", Minimum));
            }
            if (MaxLength != null && (!long.TryParse(MaxLength, out integerValue) || integerValue < 1))
            {
                context.LogError(string.Format("'{0}' is not a valid value for the 'maxLength' property. It must be a non-negative integer.", MaxLength));
            }
            if (MinLength != null && (!long.TryParse(MinLength, out integerValue) || integerValue < 1))
            {
                context.LogError(string.Format("'{0}' is not a valid value for the 'minLength' property. It must be a non-negative integer.", MinLength));
            }
            if (MaxItems != null && (!long.TryParse(MaxItems, out integerValue) || integerValue < 1))
            {
                context.LogError(string.Format("'{0}' is not a valid value for the 'maxItems' property. It must be a non-negative integer.", MaxItems));
            }
            if (MinItems != null && (!long.TryParse(MinItems, out integerValue) || integerValue < 1))
            {
                context.LogError(string.Format("'{0}' is not a valid value for the 'minItems' property. It must be a non-negative integer.", MinItems));
            }

            if (!string.IsNullOrEmpty(Pattern))
            {
                try {
                    var ptrn = new Regex(Pattern);
                }
                catch(ArgumentException ae)
                {
                    context.LogError(string.Format("'{0}' is not a valid regular expression pattern: {1}.", Pattern, ae.Message));
                }
            }
        }

        protected void CompareConstraints(SwaggerObject prior, ValidationContext context)
        {
            if ((prior.MultipleOf == null && MultipleOf != null) ||
                (prior.MultipleOf != null && !prior.MultipleOf.Equals(MultipleOf)))
            {
                context.LogBreakingChange("The new version has a different 'multipleOf' value than the previous one");
            }
            if ((prior.Maximum == null && Maximum != null) ||
                (prior.Maximum != null && !prior.Maximum.Equals(Maximum)) || 
                prior.ExclusiveMaximum != ExclusiveMaximum)
            {
                context.LogBreakingChange("The new version has a different 'maximum' or 'exclusiveMaximum' value than the previous one");
            }
            if ((prior.Minimum == null && Minimum != null) ||
                (prior.Minimum != null && !prior.Minimum.Equals(Minimum)) || 
                prior.ExclusiveMinimum != ExclusiveMinimum)
            {
                context.LogBreakingChange("The new version has a different 'minimum' or 'exclusiveMinimum' value than the previous one");
            }
            if ((prior.MaxLength == null && MaxLength != null) ||
                (prior.MaxLength != null && !prior.MaxLength.Equals(MaxLength)))
            {
                context.LogBreakingChange("The new version has a different 'maxLength' value than the previous one");
            }
            if ((prior.MinLength == null && MinLength != null) ||
                (prior.MinLength != null && !prior.MinLength.Equals(MinLength)))
            {
                context.LogBreakingChange("The new version has a different 'minLength' value than the previous one");
            }
            if ((prior.Pattern == null && Pattern != null) ||
                (prior.Pattern != null && !prior.Pattern.Equals(Pattern)))
            {
                context.LogBreakingChange("The new version has a different 'pattern' value than the previous one");
            }
            if ((prior.MaxItems  == null && MaxItems != null) ||
                (prior.MaxItems != null && !prior.MaxItems.Equals(MaxItems)))
            {
                context.LogBreakingChange("The new version has a different 'maxItems' value than the previous one");
            }
            if ((prior.MinItems == null && MinItems != null) ||
                (prior.MinItems != null && !prior.MinItems.Equals(MinItems)))
            {
                context.LogBreakingChange("The new version has a different 'minItems' value than the previous one");
            }
            if (prior.UniqueItems != UniqueItems)
            {
                context.LogBreakingChange("The new version has a different 'uniqueItems' value than the previous one");
            }
        }

        protected void CompareItems(SwaggerObject prior, ValidationContext context)
        {
            if (prior.Items != null && Items != null)
            {
                context.PushTitle(context.Title + "/items");
                Items.Compare(prior.Items, context);
                context.PopTitle();
            }
        }
    }
}