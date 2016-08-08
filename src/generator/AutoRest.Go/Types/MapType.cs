// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;

using AutoRest.Core.ClientModel;

namespace AutoRest.Go
{
    /// <summary>
    /// Defines a synthetic type used to hold an array or dictionary method response.
    /// </summary>
    public class MapType : DictionaryType
    {
        public string FieldNameFormat { get; set; }

        public string FieldName { get { return string.Format(CultureInfo.InvariantCulture, FieldNameFormat, ValueType.Name); } }

        public MapType(IType type)
        {
            ValueType = type;
            NameFormat = "map[string]{0}";
            FieldNameFormat = ValueType.CanBeNull()
                                ? NameFormat
                                : "map[string]*{0}";
        }

        /// <summary>
        /// Determines whether the specified object is equal to this object based on the ValueType.
        /// </summary>
        /// <param name="obj">The object to compare with this object.</param>
        /// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        public override bool Equals(object obj)
        {
            var mapType = obj as MapType;

            if (mapType != null)
            {
                return mapType.ValueType == ValueType;
            }

            return false;
        }

        /// <summary>
        /// Returns the hash code for this instance.
        /// </summary>
        /// <returns>A 32-bit signed integer hash code.</returns>
        public override int GetHashCode()
        {
            return ValueType.GetHashCode();
        }
    }
}
