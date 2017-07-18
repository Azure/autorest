// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents an entry in the import list.
    /// </summary>
    public sealed class ImportEntry : Node, IEquatable<ImportEntry>
    {
        /// <summary>
        /// Gets the package alias, can be null.
        /// </summary>
        public string Alias { get; }

        /// <summary>
        /// Gets the package.
        /// </summary>
        public string Package { get; }

        /// <summary>
        /// Creates a new ImportEntry object.
        /// </summary>
        /// <param name="package">The package name.</param>
        /// <param name="alias">Optional package alias.</param>
        public ImportEntry(string package, string alias = null)
        {
            if (string.IsNullOrWhiteSpace(package))
            {
                throw new ArgumentException(nameof(package));
            }

            Alias = alias;
            Package = package;
        }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("ImportEntry cannot have child nodes.");
        }

        public override int GetHashCode()
        {
            return Package.GetHashCode();
        }

        public bool Equals(ImportEntry other)
        {
            return Package == other.Package;
        }
    }
}
