// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Collections.Generic;
using Resources = Microsoft.Rest.Modeler.Swagger.Properties.Resources;
using Newtonsoft.Json;
using Microsoft.Rest.Generator.ClientModel;
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
                    if (string.Equals("unixtime", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return new PrimaryType(KnownPrimaryType.UnixTime);
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
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            var errorCount = context.ValidationErrors.Count;

            base.Validate(context);

            var validator = new SwaggerObjectValidator();
            foreach (var validationResult in validator.ValidationExceptions(this))
            {
                // TODO: put logging somewhere else
                switch (validationResult.Severity)
                {
                    case LogEntrySeverity.Warning:
                        context.LogWarning(validationResult.Message);
                        break;
                    case LogEntrySeverity.Error:
                        context.LogError(validationResult.Message);
                        break;
                }
            }

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
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            var errorCount = context.ValidationErrors.Count;

            base.Compare(priorVersion, context);

            if (Reference != null && !Reference.Equals(prior.Reference))
            {
                context.LogBreakingChange(Resources.ReferenceRedirection);
            }

            if (IsRequired != prior.IsRequired)
            {
                context.LogBreakingChange(Resources.RequiredStatusChange);
            }

            // Are the types the same?

            if (prior.Type.HasValue != Type.HasValue || (Type.HasValue && prior.Type.Value != Type.Value))
            {
                context.LogBreakingChange(Resources.TypeChanged);
            }

            // What about the formats?

            CompareFormats(prior, context);

            CompareItems(prior, context);

            if (Default != null && !Default.Equals(prior.Default) || (Default == null && !string.IsNullOrEmpty(prior.Default)))
            {
                context.LogBreakingChange(Resources.DefaultValueChanged);
            }

            if (Type.HasValue && Type.Value == DataType.Array && prior.CollectionFormat != CollectionFormat)
            {
                context.LogBreakingChange(Resources.ArrayCollectionFormatChanged);
            }

            CompareProperties(context, prior);

            CompareEnums(context, prior);

            return context.ValidationErrors.Count == errorCount;
        }

        private void CompareEnums(ValidationContext context, SwaggerObject prior)
        {
            // Was an enum value removed?

            if (prior.Enum != null)
            {
                if (this.Enum == null)
                {
                    context.LogBreakingChange(Resources.RemovedEnumValues);
                }
                else
                {
                    foreach (var e in prior.Enum)
                    {
                        if (!this.Enum.Contains(e))
                        {
                            context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.RemovedEnumValue1, e));

                        }
                    }
                }
            }
            else if (this.Enum != null)
            {
                context.LogBreakingChange(Resources.AddedEnumValues);
            }
        }

        private void CompareProperties(ValidationContext context, SwaggerObject prior)
        {
            // Additional properties

            if (prior.AdditionalProperties == null && AdditionalProperties != null)
            {
                context.LogBreakingChange(Resources.AddedAdditionalProperties);
            }
            else if (prior.AdditionalProperties != null && AdditionalProperties == null)
            {
                context.LogBreakingChange(Resources.RemovedAdditionalProperties);
            }
            else if (AdditionalProperties != null)
            {
                context.PushTitle(context.Title + "/AdditionalProperties");
                AdditionalProperties.Compare(prior.AdditionalProperties, context);
                context.PopTitle();
            }
        }

        protected void CompareFormats(SwaggerObject prior, ValidationContext context)
        {
            if (prior == null)
            {
                throw new ArgumentNullException("prior");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            if (prior.Format == null && Format != null || prior.Format != null && Format == null)
            {
                context.LogBreakingChange(Resources.TypeFormatChanged);
            }
        }

        [SuppressMessage("Microsoft.Usage", "CA1806:DoNotIgnoreMethodResults", Justification = "The call to 'new Regex' is made only to look for exceptions.")]
        private void ValidateConstraints(ValidationContext context)
        {
            double numberValue;
            long integerValue = 0;

            if (Maximum != null && !double.TryParse(Maximum, out numberValue))
            {
                context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.BadMaximum1, Maximum));
            }
            if (Minimum != null && !double.TryParse(Minimum, out numberValue))
            {
                context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.BadMinimum1, Minimum));
            }
            if (MaxLength != null && (!long.TryParse(MaxLength, out integerValue) || integerValue < 0))
            {
                context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.BadMaxLength1, MaxLength));
            }
            if (MinLength != null && (!long.TryParse(MinLength, out integerValue) || integerValue < 0))
            {
                context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.BadMinLength1, MinLength));
            }
            if (MaxItems != null && (!long.TryParse(MaxItems, out integerValue) || integerValue < 0))
            {
                context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.BadMaxItems1, MaxItems));
            }
            if (MinItems != null && (!long.TryParse(MinItems, out integerValue) || integerValue < 0))
            {
                context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.BadMinItems1, MinItems));
            }

            if (!string.IsNullOrEmpty(Pattern))
            {
                try
                {
                    new Regex(Pattern);
                }
                catch (ArgumentException ae)
                {
                    context.LogError(string.Format(CultureInfo.InvariantCulture, Resources.InvalidPattern2, Pattern, ae.Message));
                }
            }
        }

        [SuppressMessage("Microsoft.Maintainability", "CA1502:AvoidExcessiveComplexity", Justification = "It may look complex, but it really isn't.")]
        protected void CompareConstraints(SwaggerObject prior, ValidationContext context)
        {
            if (prior == null)
            {
                throw new ArgumentNullException("prior");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            if ((prior.MultipleOf == null && MultipleOf != null) ||
                (prior.MultipleOf != null && !prior.MultipleOf.Equals(MultipleOf)))
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "multipleOf"));
            }
            if ((prior.Maximum == null && Maximum != null) ||
                (prior.Maximum != null && !prior.Maximum.Equals(Maximum)) ||
                prior.ExclusiveMaximum != ExclusiveMaximum)
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "maximum"));
            }
            if ((prior.Minimum == null && Minimum != null) ||
                (prior.Minimum != null && !prior.Minimum.Equals(Minimum)) ||
                prior.ExclusiveMinimum != ExclusiveMinimum)
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "minimum"));
            }
            if ((prior.MaxLength == null && MaxLength != null) ||
                (prior.MaxLength != null && !prior.MaxLength.Equals(MaxLength)))
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "maxLength"));
            }
            if ((prior.MinLength == null && MinLength != null) ||
                (prior.MinLength != null && !prior.MinLength.Equals(MinLength)))
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "minLength"));
            }
            if ((prior.Pattern == null && Pattern != null) ||
                (prior.Pattern != null && !prior.Pattern.Equals(Pattern)))
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "pattern"));
            }
            if ((prior.MaxItems == null && MaxItems != null) ||
                (prior.MaxItems != null && !prior.MaxItems.Equals(MaxItems)))
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "maxItems"));
            }
            if ((prior.MinItems == null && MinItems != null) ||
                (prior.MinItems != null && !prior.MinItems.Equals(MinItems)))
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "minItems"));
            }
            if (prior.UniqueItems != UniqueItems)
            {
                context.LogBreakingChange(string.Format(CultureInfo.InvariantCulture, Resources.PropertyValueChanged1, "uniqueItems"));
            }
        }

        protected void CompareItems(SwaggerObject prior, ValidationContext context)
        {
            if (prior == null)
            {
                throw new ArgumentNullException("prior");
            }
            if (context == null)
            {
                throw new ArgumentNullException("context");
            }

            if (prior.Items != null && Items != null)
            {
                context.PushTitle(context.Title + "/items");
                Items.Compare(prior.Items, context);
                context.PopTitle();
            }
        }
    }
}