// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines enumeration values.
    /// </summary>
    public class EnumValue : IComparable
    {
        /// <summary>
        /// Gets or sets the enum value name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the enum value serialized name.
        /// </summary>
        public string SerializedName { get; set; }

        /// <summary>
        /// Determines whether the specified object is equal to this object based on Name.
        /// </summary>
        /// <param name="obj">The object to compare with this object.</param>
        /// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        public override bool Equals(object obj)
        {
            var enumType = obj as EnumValue;

            if (enumType != null)
            {
                return enumType.Name == Name;
            }
            return false;
        }

        /// <summary>
        /// Serves as a hash function based on name.
        /// </summary>
        /// <returns>
        /// A hash code for the current object.
        /// </returns>
        public override int GetHashCode()
        {
            return Name.GetHashCode();
        }

        public int CompareTo(object obj)
        {
            var enumType = obj as EnumValue;

            if (enumType != null)
            {
                return String.Compare(enumType.Name, Name, StringComparison.Ordinal);
            }

            return -1;
        }
    }
}