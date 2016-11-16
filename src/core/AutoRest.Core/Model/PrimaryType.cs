// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;

namespace AutoRest.Core.Model
{
    /// <summary>
    ///     Defines known model type.
    /// </summary>
    public class PrimaryType : ModelType
    {
        protected PrimaryType()
        {
        }

        /// <summary>
        ///     Initializes a new instance of PrimaryType class from a known type.
        /// </summary>
        protected PrimaryType(KnownPrimaryType knownPrimaryType)
        {
            KnownPrimaryType = knownPrimaryType;
            Name = KnownPrimaryType.ToString();
        }

        public override IEnumerable<IChild> Children => Enumerable.Empty<IChild>();
        public override string Qualifier => "PrimaryType";

        public override string RefName => $"AutoRest.Core.Model.PrimaryType, AutoRest.Core";

        /// <summary>
        ///     Gets or sets the model type format.
        /// </summary>
        public virtual string Format { get; set; }

        /// <summary>
        ///     Returns the KnownFormat of the Format string (provided it matches a KnownFormat)
        ///     Otherwise, returns KnownFormat.none
        /// </summary>
        public KnownFormat KnownFormat => KnownFormatExtensions.Parse(Format);

        /// <summary>
        ///     Gets or sets the underlying known type.
        /// </summary>
        public KnownPrimaryType KnownPrimaryType { get; set; }

        /// <Summary>
        /// Backing field for <code>SerializedName</code> property. 
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _serializedName = new Fixable<string>();

        /// <Summary>
        /// The name on the wire for the model type.
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

        public override void Disambiguate()
        {
            // not needed, right?
        }

        /// <summary>
        ///     Returns a string representation of the PrimaryType object.
        /// </summary>
        /// <returns>
        ///     A string representation of the PrimaryType object.
        /// </returns>
        public override string ToString()
        {
            return Name;
        }

        /// <summary>
        /// Determines whether the specified model type is structurally equal to this object.
        /// </summary>
        /// <param name="other">The object to compare with this object.</param>
        /// <returns>true if the specified object is functionally equal to this object; otherwise, false.</returns>
        public override bool StructurallyEquals(IModelType other)
        {
            if (ReferenceEquals(other as PrimaryType, null))
            {
                return false;
            }

            return base.StructurallyEquals(other) && 
                KnownPrimaryType == (other as PrimaryType).KnownPrimaryType &&
                Format == (other as PrimaryType).Format;
        }
    }
}