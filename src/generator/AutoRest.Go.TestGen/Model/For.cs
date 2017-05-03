// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a for statement.
    /// </summary>
    public sealed class For : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }
    }
}
