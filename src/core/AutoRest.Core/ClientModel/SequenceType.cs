// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;

namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Defines a collection data type.
    /// </summary>
    public class SequenceType : IType
    {
        public SequenceType()
        {
            NameFormat = "IList<{0}>";
        }

        /// <summary>
        /// Gets or sets the element type of the collection.
        /// </summary>
        public IType ElementType { get; set; }

        /// <summary>
        /// Gets or sets the sequence type name format. Defaults to C# list
        /// </summary>
        public string NameFormat { get; set; }

        /// <summary>
        /// Gets the type name
        /// </summary>
        public string Name { get { return string.Format(CultureInfo.InvariantCulture, NameFormat, ElementType.Name); } }

        /// <summary>
        /// Returns a string representation of the SequenceType object.
        /// </summary>
        /// <returns>
        /// A string representation of the SequenceType object.
        /// </returns>
        public override string ToString()
        {
            return Name;
        }

        /// <summary>
        /// Determines whether the specified object is equal to this object based on the ElementType.
        /// </summary>
        /// <param name="obj">The object to compare with this object.</param>
        /// <returns>true if the specified object is equal to this object; otherwise, false.</returns>
        public override bool Equals(object obj)
        {
            var sequenceType = obj as SequenceType;

            if (sequenceType != null)
            {
                return sequenceType.ElementType == ElementType;
            }

            return false;
        }

        /// <summary>
        /// Serves as a hash function based on ElementType.
        /// </summary>
        /// <returns>
        /// A hash code for the current object.
        /// </returns>
        public override int GetHashCode()
        {
            return ElementType.GetHashCode();
        }
    }
}