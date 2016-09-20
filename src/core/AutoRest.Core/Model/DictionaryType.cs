// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines a key-value dictionary type with string key data type.
    /// </summary>
    public class DictionaryType : ModelType
    {
        protected DictionaryType()
        {
            Name.OnGet += value => $"Dictionary<string,{ValueType}";
        }

        /// <summary>
        /// Gets or sets the value type of the dictionary type.
        /// </summary>        
        public virtual IModelType ValueType { get; set; }

        /// <summary>
        /// Indicates that the class should deserialize properties with no matching class member into this collection.
        /// </summary>
        public virtual bool SupportsAdditionalProperties { get; set; }

        public override string RefName => "AutoRest.Core.Model.DictionaryType, AutoRest.Core";
        public override string Qualifier => "Dictionary";
        public override void Disambiguate()
        {
            // not needed, right?
        }

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