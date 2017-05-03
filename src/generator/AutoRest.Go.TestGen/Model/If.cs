// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents an if statement.
    /// </summary>
    public sealed class If : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }
    }
}
