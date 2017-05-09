// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Builders;
using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a function return value signature.
    /// </summary>
    public sealed class FuncReturnSig : Node
    {
        /// <summary>
        /// Creates a new FuncReturnSig object.
        /// </summary>
        /// <param name="name">The optional variable name.  Pass null if there is no name.</param>
        /// <param name="modifier">How the return value is passed.</param>
        /// <param name="typeName">The type name of the param.</param>
        public FuncReturnSig(string name, TypeModifier modifier, string typeName)
        {
            if (name != null && string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException("pass null for name when there is no variable name");
            }

            if (string.IsNullOrEmpty(typeName))
            {
                throw new ArgumentException(nameof(TypeName));
            }

            if (name != null)
            {
                var id = new Identifier(name);
                base.AddChild(id);
                IsNamed = true;
            }

            var type = new TypeName(typeName);

            if (modifier == TypeModifier.ByReference)
            {
                base.AddChild(UnaryOpSequence.Generate(UnaryOperatorType.Star, type));
            }
            else
            {
                base.AddChild(type);
            }
        }

        /// <summary>
        /// Returns true if this return value is named.
        /// </summary>
        public bool IsNamed { get; }

        public override void Accept(INodeVisitor visitor)
        {
            // emtpy
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("FuncReturnSig cannot have child nodes");
        }
    }
}
