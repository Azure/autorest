// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines enumeration values.
    /// </summary>
    public class EnumValue : IComparable, IChild
    {
        /// <summary>
        /// Gets or sets the literal enum value name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// The member name to generate for this value.
        /// </summary>
        public string MemberName => CodeNamer.Instance.GetEnumMemberName(Name);

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

        public virtual string Qualifier => "EnumValue";
        public virtual string QualifierType => "Enum Value";

        public virtual IEnumerable<string> MyReservedNames
        {
            get
            {
                if( !string.IsNullOrEmpty(Name) ) { yield return Name;}
            }
        }

        public virtual HashSet<string> LocallyUsedNames => null;

        public IParent Parent => null;

        public virtual void Disambiguate()
        {
            // not needed, right?
        }
    }
}