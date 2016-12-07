// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;

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

        /// <Summary>
        /// Backing field for <code>SerializedName</code> property. 
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _serializedName = new Fixable<string>();

        /// <Summary>
        /// The name on the wire for the Enum Value.
        /// </Summary>
        /// <remarks>
        /// The Get and Set operations for this accessor may be overridden by using the 
        /// <code>SerializedName.OnGet</code> and <code>SerializedName.OnSet</code> events in this class' constructor.
        /// (ie <code> SerializedName.OnGet += serializedName => serializedName.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> SerializedName
        {
            get { return _serializedName; }
            set { _serializedName.CopyFrom(value); }
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