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
using AutoRest.Core.ClientModel;

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
                && "file".Equals(_schema.Format, StringComparison.OrdinalIgnoreCase))
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