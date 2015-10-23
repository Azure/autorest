// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Modeler.Swagger.Properties;

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
                        return PrimaryType.Date;
                    }
                    if (string.Equals("date-time", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return PrimaryType.DateTime;
                    }
                    if (string.Equals("date-time-rfc1123", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return PrimaryType.DateTimeRfc1123;
                    }
                    if (string.Equals("byte", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return PrimaryType.ByteArray;
                    }
                    if (string.Equals("duration", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return PrimaryType.TimeSpan;
                    }
                    return PrimaryType.String;
                case DataType.Number:
                    if (string.Equals("decimal", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return PrimaryType.Decimal;
                    }
                    return PrimaryType.Double;
                case DataType.Integer:
                    if (string.Equals("int64", Format, StringComparison.OrdinalIgnoreCase))
                    {
                        return PrimaryType.Long;
                    }
                    return PrimaryType.Int;
                case DataType.Boolean:
                    return PrimaryType.Boolean;
                case DataType.Object:
                case DataType.Array:
                case null:
                    return PrimaryType.Object;
                case DataType.File:
                    return PrimaryType.Stream;
                default:
                    throw new NotImplementedException(
                        string.Format(CultureInfo.InvariantCulture, 
                           Resources.InvalidTypeInSwaggerSchema,
                            Type));
            }
        }
    }
}