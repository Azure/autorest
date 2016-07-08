// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines a key-value dictionary type with string key data type.
    /// </summary>
    public class DictionaryType : IType
    {
        public DictionaryType()
        {
            NameFormat = "IDictionary<string, {0}>";
        }

        /// <summary>
        /// Gets or sets the value type of the dictionary type.
        /// </summary>        
        public IType ValueType { get; set; }

        /// <summary>
        /// Gets or sets the dictionary type name format. Defaults to C# dictionary
        /// </summary>
        public string NameFormat { get; set; }

        /// <summary>
        /// Indicates that the class should deserialize properties with no matching class member into this collection.
        /// </summary>
        public bool SupportsAdditionalProperties { get; set; }


        /// <summary>
        /// Gets the type name
        /// </summary>
        public string Name { get { return string.Format(CultureInfo.InvariantCulture, NameFormat, ValueType.Name); } }

        /// <summary>
        /// Returns a string representation of the DictionaryType object.
        /// </summary>
        /// <returns>
        /// A string representation of the DictionaryType object.
        /// </returns>
        public override string ToString()
        {
            return Name;
        }

        /// <summary>
        /// Determines whether the specified object is equal to this object based on the ValueType.
        /// </summary>
        /// <param name="obj">The object to compare with this object.</param>
        /// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        public override bool Equals(object obj)
        {
            var dictionaryType = obj as DictionaryType;

            if (dictionaryType != null)
            {
                return dictionaryType.ValueType == ValueType;
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