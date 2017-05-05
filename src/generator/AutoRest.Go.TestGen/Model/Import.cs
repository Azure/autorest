// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents an import statement.
    /// </summary>
    public sealed class Import : Node
    {
        private HashSet<ImportEntry> _imports;

        public Import()
        {
            _imports = new HashSet<ImportEntry>();
        }

        public override void Accept(INodeVisitor visitor)
        {
            var start = new OpenDelimiter(BinaryDelimiterType.Paren);
            foreach (var i in _imports)
            {
                start.AddChild(i);
            }

            start.AddClosingDelimiter();
            base.AddChild(start);

            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            if (child as ImportEntry == null)
            {
                throw new InvalidOperationException("Children of Import must be of type ImportEntry.");
            }

            _imports.Add((ImportEntry)child);
        }

        /// <summary>
        /// Adds multiple ImportEntry objects wrapped in parenthesis.
        /// </summary>
        /// <param name="imports">The ImportEntry objects to be added.</param>
        public void AddRange(IEnumerable<ImportEntry> imports)
        {
            foreach (var import in imports)
            {
                _imports.Add(import);
            }
        }

        /// <summary>
        /// Checks if the specified import has already been added.
        /// </summary>
        /// <param name="import">The import to check.</param>
        /// <returns>True if the import has already been added.</returns>
        public bool Contains(ImportEntry import)
        {
            return _imports.Contains(import);
        }
    }
}
