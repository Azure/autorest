// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a comment.
    /// </summary>
    public sealed class Comment : Node
    {
        /// <summary>
        /// Gets the comment text.
        /// </summary>
        public string Text { get; }

        /// <summary>
        /// Creates a new Comment object.
        /// </summary>
        /// <param name="text">The body of the comment.</param>
        public Comment(string text)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                throw new ArgumentException(nameof(text));
            }

            Text = text;
        }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("Comment object cannot have child nodes.");
        }
    }
}
