// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;

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

        /// <summary>
        ///     Gets or sets the model type name on the wire.
        /// </summary>
        public virtual string SerializedName { get; set; }

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
    }
}