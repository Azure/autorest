// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a source file.
    /// </summary>
    public sealed class File : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            // file doesn't do anything with the visitor
        }
    }
}
