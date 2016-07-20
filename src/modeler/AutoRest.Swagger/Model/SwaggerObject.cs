// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Validation;
using Newtonsoft.Json;

namespace AutoRest.Swagger.Model
{
    /// <summary>
    /// Describes a single operation determining with this object is mandatory.
    /// https://github.com/wordnik/swagger-spec/blob/master/versions/2.0.md#parameterObject
    /// </summary>
    [Serializable]
    [Rule(typeof(DescriptionRequired))]
    [Rule(typeof(DefaultMustBeInEnum))]
    [Rule(typeof(RefsMustNotHaveSiblings))]
    public abstract class SwaggerObject : SwaggerBase
    {
        private string _description;
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
        /// Returns the KnownFormat of the Format string (provided it matches a KnownFormat)
        /// Otherwise, returns KnownFormat.none
        /// </summary>
        public KnownFormat KnownFormat => KnownFormatExtensions.Parse(Format);

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

        [Rule(typeof(DescriptiveDescriptionRequired))]
        public virtual string Description
        {
            get { return _description; }
            set { _description = value.StripControlCharacters(); }
        }

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

        /// <summary>
        /// Returns the PrimaryType that the SwaggerObject maps to, given the Type and the KnownFormat.
        /// 
        /// Note: Since a given language still may interpret the value of the Format after this, 
        /// it is possible the final implemented type may not be the type given here. 
        /// 
        /// This allows languages to not have a specific PrimaryType decided by the Modeler.
        /// 
        /// For example, if the Type is DataType.String, and the KnownFormat is 'char' the C# generator 
        /// will end up creating a char type in the generated code, but other languages will still 
        /// use string.
        /// </summary>
        /// <returns>
        /// The PrimaryType that best represents this object.
        /// </returns>
        public PrimaryType ToType()
        {
            switch (Type)
            {
                case DataType.String:
                    switch (KnownFormat)
                    {
                        case KnownFormat.date:
                        return new PrimaryType(KnownPrimaryType.Date);
                        case KnownFormat.date_time:
                        return new PrimaryType(KnownPrimaryType.DateTime);
                        case KnownFormat.date_time_rfc1123:
                        return new PrimaryType(KnownPrimaryType.DateTimeRfc1123);
                        case KnownFormat.@byte:
                        return new PrimaryType(KnownPrimaryType.ByteArray);
                        case KnownFormat.duration:
                        return new PrimaryType(KnownPrimaryType.TimeSpan);
                        case KnownFormat.uuid:
                        return new PrimaryType(KnownPrimaryType.Uuid);
                        case KnownFormat.base64url:
                        return new PrimaryType(KnownPrimaryType.Base64Url);
                        default:
                            return new PrimaryType(KnownPrimaryType.String);
                    }
                   
                case DataType.Number:
                    switch (KnownFormat)
                    {
                        case KnownFormat.@decimal:
                        return new PrimaryType(KnownPrimaryType.Decimal);
                        default:
                            return new PrimaryType(KnownPrimaryType.Double);
                    }

                case DataType.Integer:
                    switch (KnownFormat)
                    {
                        case KnownFormat.int64:
                        return new PrimaryType(KnownPrimaryType.Long);
                        case KnownFormat.unixtime:
                        return new PrimaryType(KnownPrimaryType.UnixTime);
                        default:
                            return new PrimaryType(KnownPrimaryType.Int);
                    }

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
    }
}