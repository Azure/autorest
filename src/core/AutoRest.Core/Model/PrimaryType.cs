// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines known model type.
    /// </summary>
    public class PrimaryType : IType
    {
        /// <summary>
        /// Initializes a new instance of PrimaryType class from a known type.
        /// </summary>
        public PrimaryType(KnownPrimaryType type)
        {
            Type = type;
            Name = Type.ToString();
        }

        /// <summary>
        /// Gets or sets the underlying known type.
        /// </summary>
        public KnownPrimaryType Type { get; set; }

        /// <summary>
        /// Gets or sets the model type name on the wire.
        /// </summary>
        public string SerializedName { get; set; }

        /// <summary>
        /// Gets or sets the model type name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the model type format.
        /// </summary>
        public string Format { get; set; }

        /// <summary>
        /// Returns the KnownFormat of the Format string (provided it matches a KnownFormat)
        /// Otherwise, returns KnownFormat.none
        /// </summary>
        public KnownFormat KnownFormat => KnownFormatExtensions.Parse(Format);

        /// <summary>
        /// Returns a string representation of the PrimaryType object.
        /// </summary>
        /// <returns>
        /// A string representation of the PrimaryType object.
        /// </returns>
        public override string ToString()
        {
            return Name;
        }        
    }
}
