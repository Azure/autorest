// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;

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
        [JsonIgnore]
        public override string Qualifier => "PrimaryType";

        /// <summary>
        ///     Gets or sets the model type format.
        /// </summary>
        public virtual string Format { get; set; }

        /// <summary>
        ///     Returns the KnownFormat of the Format string (provided it matches a KnownFormat)
        ///     Otherwise, returns KnownFormat.none
        /// </summary>
        [JsonIgnore]
        public KnownFormat KnownFormat => KnownFormatExtensions.Parse(Format);

        /// <summary>
        ///     Gets or sets the underlying known type.
        /// </summary>
        public KnownPrimaryType KnownPrimaryType { get; set; }

        public override void Disambiguate()
        {
            // not needed, right?
        }
    }
}