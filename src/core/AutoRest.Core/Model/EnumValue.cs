// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines enumeration values.
    /// </summary>
    public class EnumValue : IComparable, IChild
    {
        /// <summary>
        /// Gets or sets the enum value's description.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets the literal enum value name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// The member name to generate for this value.
        /// </summary>
        [JsonIgnore]
        public string MemberName => CodeNamer.Instance.GetEnumMemberName(Name);

        /// <summary>
        /// The name on the wire for the Enum Value.
        /// </summary>
        public string SerializedName { get; set; }

        public int CompareTo(object obj)
        {
            var enumType = obj as EnumValue;

            if (enumType != null)
            {
                return String.Compare(enumType.Name, Name, StringComparison.Ordinal);
            }

            return -1;
        }

        [JsonIgnore]
        public virtual string Qualifier => "EnumValue";

        [JsonIgnore]
        public virtual IEnumerable<string> MyReservedNames
        {
            get
            {
                if( !string.IsNullOrEmpty(Name) ) { yield return Name;}
            }
        }

        public virtual HashSet<string> LocallyUsedNames => null;

        [JsonIgnore]
        public IParent Parent => null;

        public virtual void Disambiguate()
        {
            // not needed, right?
        }
    }
}