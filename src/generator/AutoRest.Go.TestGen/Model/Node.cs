// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a node in the AST.
    /// </summary>
    public abstract class Node
    {
        private List<Node> _children;

        /// <summary>
        /// Takes an INodeVisitor object that will visit the derived type.
        /// </summary>
        /// <param name="visitor">The INodeVisitor to visit this object.</param>
        public abstract void Accept(INodeVisitor visitor);

        /// <summary>
        /// Gets the child nodes for this node; can be empty.
        /// </summary>
        public IReadOnlyList<Node> Children { get { return _children; } }

        /// <summary>
        /// Gets the parent node for this node; can be null.
        /// </summary>
        public Node Parent { get; private set; }

        /// <summary>
        /// Creates a new Node object.
        /// </summary>
        public Node()
        {
            _children = new List<Node>();
        }

        /// <summary>
        /// Visit this node and its children.
        /// </summary>
        /// <param name="visitor">Object that implements INodeVisitor.</param>
        public virtual void Visit(INodeVisitor visitor)
        {
            Accept(visitor);

            foreach (var child in Children)
            {
                child.Visit(visitor);
            }
        }

        /// <summary>
        /// Adds the specified Node as a child of this node.
        /// Sets the node's parent field to this node.
        /// </summary>
        /// <param name="child">The node to be added as a child node.</param>
        public virtual void AddChild(Node child)
        {
            if (child.Parent != null)
            {
                throw new InvalidOperationException("node already has a parent");
            }

            child.Parent = this;
            _children.Add(child);
        }
    }
}
