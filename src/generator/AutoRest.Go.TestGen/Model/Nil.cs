// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents the nil keyword.
    /// </summary>
    public sealed class Nil : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("nil cannot have child nodes");
        }
    }
}
