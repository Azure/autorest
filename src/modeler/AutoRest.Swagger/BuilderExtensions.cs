// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.JsonConverters;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Properties;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using AutoRest.Core.Model;

namespace AutoRest.Swagger
{
    public static class BuilderExtensions
    {
        /// <summary>
        /// A schema represents a primitive type if it's not an object or it represents a dictionary
        /// </summary>
        /// <param name="_schema"></param>
        /// <returns></returns>
        public static bool IsPrimitiveType(this Schema _schema)
        {
            // Notes: 
            //      'additionalProperties' on a type AND no defined 'properties', indicates that
            //      this type is a Dictionary. (and is handled by ObjectBuilder)
            return (_schema.Type != null && _schema.Type != DataType.Object || (_schema.AdditionalProperties != null && _schema.Properties.IsNullOrEmpty()));
        }

        /// <summary>
        /// A schema represents a simple primary type if it's a stream, or an object with no properties
        /// </summary>
        /// <param name="_schema"></param>
        /// <returns></returns>
        public static KnownPrimaryType GetSimplePrimaryType(this Schema _schema)
        {
            // If object with file format treat as stream
            if (_schema.Type != null
                && _schema.Type == DataType.Object
                && "file".EqualsIgnoreCase(_schema.Format))
            {
                return KnownPrimaryType.Stream;
            }

            // If the object does not have any properties, treat it as raw json (i.e. object)
            if (_schema.Properties.IsNullOrEmpty() && string.IsNullOrEmpty(_schema.Extends) && _schema.AdditionalProperties == null)
            {
                return KnownPrimaryType.Object;
            }

            // The schema doesn't match any KnownPrimaryType
            return KnownPrimaryType.None;
        }

        /// <summary>
        /// Determines if a constraint is supported for the SwaggerObject Type
        /// </summary>
        /// <param name="constraintName"></param>
        /// <returns></returns>
        public static bool IsConstraintSupported(this SwaggerObject swaggerObject, string constraintName)
        {
            switch (swaggerObject.Type)
            {
                case DataType.Array:
                    return (constraintName == Constraint.MinItems.ToString() ||
                            constraintName == Constraint.MaxItems.ToString() ||
                            constraintName == Constraint.UniqueItems.ToString());
                case DataType.Integer:
                case DataType.Number:
                    return constraintName == Constraint.ExclusiveMaximum.ToString() ||
                           constraintName == Constraint.ExclusiveMinimum.ToString() ||
                           constraintName == Constraint.MultipleOf.ToString() ||
                           constraintName == "Minimum" || constraintName == "Maximum";
                case DataType.String:
                    return (constraintName == Constraint.MinLength.ToString() ||
                            constraintName == Constraint.MaxLength.ToString() ||
                            constraintName == Constraint.Pattern.ToString());
                 default:
                    return false;
            }
        }

        /// <summary>
        /// A schema represents a CompositeType if it's not a primitive type and it's not a simple primary type
        /// </summary>
        /// <param name="schema"></param>
        /// <returns></returns>
        public static bool RepresentsCompositeType(this Schema schema)
        {
            return !schema.IsPrimitiveType() && schema.GetSimplePrimaryType() == KnownPrimaryType.None;
        }
    }
}