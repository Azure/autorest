// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines a model type for enumerations.
    /// </summary>
    public class EnumType : ModelType
    {
        [JsonIgnore]
        protected virtual string ModelAsStringType => New<PrimaryType>(KnownPrimaryType.String).Name;

        [JsonIgnore]
        public override string Qualifier => "Enum";
        [JsonIgnore]
        public override IEnumerable<IChild> Children => Values;

        /// <summary>
        /// Creates a new instance of EnumType object.
        /// </summary>
        protected EnumType()
        {
            Values = new List<EnumValue>();
            Name.OnGet += s => string.IsNullOrEmpty(s) ? "enum" : CodeNamer.Instance.GetTypeName(s);
        }

        /// <summary>
        /// Gets or sets the enum values. 
        /// </summary>
        public List<EnumValue> Values { get; private set; }

        /// <Summary>
        /// Backing field for <code>SerializedName</code> property. 
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _serializedName = new Fixable<string>();

        /// <Summary>
        /// The name on the wire for the Enum.
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

        public void SetName(string name)
        {
            Name = name;
        }

        /// <summary>
        /// Indicates whether the set of enum values will be generated as string constants.
        /// </summary>
        public bool ModelAsString { get; set; }

        [JsonIgnore]
        public override string DeclarationName => ModelAsString ? ModelAsStringType : base.DeclarationName;

        /// <summary>
        /// Determines whether the specified model type is structurally equal to this object.
        /// </summary>
        /// <param name="other">The object to compare with this object.</param>
        /// <returns>true if the specified object is functionally equal to this object; otherwise, false.</returns>
        public override bool StructurallyEquals(IModelType other)
        {
            if (ReferenceEquals(other as EnumType, null))
            {
                return false;
            }

            return Name == other.Name &&
                Values.OrderBy(t => t).SequenceEqual((other as EnumType).Values.OrderBy(t => t), new Utilities.EqualityComparer<EnumValue>((a, b) => a.Name == b.Name)) &&
                ModelAsString == (other as EnumType).ModelAsString;
        }

        [JsonIgnore]
        public override string ExtendedDocumentation
            => $"Possible values include: {string.Join(", ", Values.Select(v => $"'{v.Name}'"))}";
    }
}