// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest.Generator.ClientModel
{
    /// <summary>
    /// Defines known model type.
    /// </summary>
    public class PrimaryType : IType
    {
        /// <summary>
        /// Predefined dictionary of known types.
        /// </summary>
        private static Dictionary<SupportedPrimaryType, PrimaryType> KnownTypes;

        /// <summary>
        /// Initializes static members of PrimaryType class.
        /// </summary>
        static PrimaryType()
        {
            Reset();
        }

        public static void Reset()
        {
            KnownTypes = new Dictionary<SupportedPrimaryType, PrimaryType>();
            foreach (SupportedPrimaryType knownType in System.Enum.GetValues(typeof (SupportedPrimaryType)))
            {
                var name = System.Enum.GetName(typeof (SupportedPrimaryType), knownType);
                KnownTypes[knownType] = new PrimaryType {Name = name, Type = knownType};
            }
        }

        /// <summary>
        /// Gets or sets the model type.
        /// </summary>
        private SupportedPrimaryType Type { get; set; }

        /// <summary>
        /// Gets or sets the model type name on the wire.
        /// </summary>
        public string SerializedName { get; set; }

        public static PrimaryType Object
        {
            get { return KnownTypes[SupportedPrimaryType.Object]; }
        }

        public static PrimaryType Int
        {
            get { return KnownTypes[SupportedPrimaryType.Int]; }
        }

        public static PrimaryType Long
        {
            get { return KnownTypes[SupportedPrimaryType.Long]; }
        }

        public static PrimaryType Double
        {
            get { return KnownTypes[SupportedPrimaryType.Double]; }
        }

        public static PrimaryType Decimal
        {
            get { return KnownTypes[SupportedPrimaryType.Decimal]; }
        }

        public static PrimaryType String
        {
            get { return KnownTypes[SupportedPrimaryType.String]; }
        }

        public static PrimaryType Stream
        {
            get { return KnownTypes[SupportedPrimaryType.Stream]; }
        }

        public static PrimaryType ByteArray
        {
            get { return KnownTypes[SupportedPrimaryType.ByteArray]; }
        }

        public static PrimaryType Date
        {
            get { return KnownTypes[SupportedPrimaryType.Date]; }
        }

        public static PrimaryType DateTime
        {
            get { return KnownTypes[SupportedPrimaryType.DateTime]; }
        }

        public static PrimaryType DateTimeRfc1123
        {
            get { return KnownTypes[SupportedPrimaryType.DateTimeRfc1123]; }
        }

        public static PrimaryType TimeSpan
        {
            get { return KnownTypes[SupportedPrimaryType.TimeSpan]; }
        }

        public static PrimaryType Boolean
        {
            get { return KnownTypes[SupportedPrimaryType.Boolean]; }
        }

        public static PrimaryType Credentials
        {
            get { return KnownTypes[SupportedPrimaryType.Credentials]; }
        }

        /// <summary>
        /// Gets or sets the model type name.
        /// </summary>
        public string Name { get; set; }

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

        /// <summary>
        /// Determines whether the specified object is equal to this object based on Name and Type.
        /// </summary>
        /// <param name="obj">The object to compare with this object.</param>
        /// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        public override bool Equals(object obj)
        {
            var knownType = obj as PrimaryType;

            if (knownType != null)
            {
                return knownType.Type == Type && knownType.Name == Name;
            }

            return false;
        }

        /// <summary>
        /// Serves as a hash function based on Type.
        /// </summary>
        /// <returns>
        /// A hash code for the current object.
        /// </returns>
        public override int GetHashCode()
        {
            return Type.GetHashCode();
        }

        /// <summary>
        /// Available known model types.
        /// </summary>
        private enum SupportedPrimaryType
        {
            None = 0,
            Object,
            Int,
            Long,
            Double,
            Decimal,
            String,
            Stream,
            ByteArray,
            Date,
            DateTime,
            DateTimeRfc1123,
            TimeSpan,
            Boolean,
            Credentials
        }
    }
}
