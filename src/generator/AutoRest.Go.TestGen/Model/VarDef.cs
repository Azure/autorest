// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a variable definition.
    /// </summary>
    public sealed class VarDef : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }
    }
}
