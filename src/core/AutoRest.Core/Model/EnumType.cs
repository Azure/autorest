// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines a model type for enumerations.
    /// </summary>
    public class EnumType : ModelType
    {
        protected virtual string ModelAsStringType => New<PrimaryType>(KnownPrimaryType.String).Name;

        public override string RefName => "AutoRest.Core.Model.EnumType, AutoRest.Core";
        public override string Qualifier => "Enum";
        public override string QualifierType => "EnumType";
        public override IEnumerable<IChild> Children => Values;

        /// <summary>
        /// Creates a new instance of EnumType object.
        /// </summary>
        protected EnumType()
        {
            Values = new List<EnumValue>();
        }

        /// <summary>
        /// Gets or sets the enum values. 
        /// </summary>
        public List<EnumValue> Values { get; private set; }

        /// <summary>
        /// Gets or sets the model type name on the wire.
        /// </summary>
        public string SerializedName { get; set; }

        public void SetName(string name)
        {
            Name = name;
        }

        /// <summary>
        /// Indicates whether the set of enum values will be generated as string constants.
        /// </summary>
        public bool ModelAsString { get; set; }

        public override string DeclarationName => ModelAsString ? ModelAsStringType : base.DeclarationName;

        /// <summary>
        /// Returns a string representation of the PrimaryType object.
        /// </summary>
        /// <returns>
        /// A string representation of the PrimaryType object.
        /// </returns>
        public override string ToString()
        {
            if (string.IsNullOrEmpty(Name))
            {
                return "enum";
            }

            return Name;
        }

        /// <summary>
        /// Determines whether the specified object is equal to this object based on Name and Values.
        /// </summary>
        /// <param name="obj">The object to compare with this object.</param>
        /// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        public override bool Equals(object obj)
        {
            var enumType = obj as EnumType;

            if (enumType != null)
            {
                return enumType.Name.FixedValue == Name.FixedValue &&
                    enumType.Values.OrderBy(t => t).SequenceEqual(Values.OrderBy(t => t));
            }
            return false;
        }

        /// <summary>
        /// Serves as a hash function based on value count.
        /// </summary>
        /// <returns>
        /// A hash code for the current object.
        /// </returns>
        public override int GetHashCode()
        {
            return Values.Count;
        }

        public override string ExtendedDocumentation
            => $"Possible values include: {string.Join(", ", Values.Select(v => $"'{v.Name}'"))}";
    }
}