// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;

using AutoRest.Core.ClientModel;

namespace AutoRest.Go
{
    /// <summary>
    /// Defines type defined by a Go package.
    /// </summary>
    public class PackageType : IType
    {
        /// <summary>
        /// Gets or sets the model type import.
        /// This must be the full package name (e.g., "net/http").
        /// </summary>
        public string Import { get; set; }

        public IEnumerable<string> Imports()
        {
            return new List<string> { Import };
        }

        /// <summary>
        /// Gets or sets the member name.
        /// </summary>
        public string Member { get; set; }

        /// <summary>
        /// Gets or sets the model type name.
        /// </summary>
        public string Name
        {
            get
            {
                return string.Format("{0}.{1}", Package, Member);
            }
        }

        public string Package
        {
            get
            {
                var parts = (Import ?? String.Empty).Split(new char[] { '/' });
                return parts[parts.Length - 1];
            }
        }

        /// <summary>
        /// Returns a string representation of the PackageType object.
        /// </summary>
        /// <returns>
        /// A string representation of the PackageType object.
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
            var knownType = obj as PackageType;

            if (knownType != null)
            {
                return knownType.Import == Import && knownType.Member == Member;
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
            return (Import + "." + Member).GetHashCode();
        }
    }
}
