// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Builders;
using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Indicates how the parameter is to be passed.
    /// </summary>
    public enum TypeModifier
    {
        ByReference,
        ByValue
    }

    /// <summary>
    /// Represents a function parameter signature.
    /// </summary>
    public sealed class FuncParamSig : Node
    {
        /// <summary>
        /// Creates a new FuncParamSig object.
        /// </summary>
        /// <param name="name">The name of the param.</param>
        /// <param name="modifier">How the param is passed.</param>
        /// <param name="typeName">The type name of the param.</param>
        public FuncParamSig(string name, TypeModifier modifier, string typeName)
        {
            if (string.IsNullOrEmpty(name))
            {
                throw new ArgumentException(nameof(name));
            }

            if (string.IsNullOrEmpty(typeName))
            {
                throw new ArgumentException(nameof(typeName));
            }

            var id = new Identifier(name);
            base.AddChild(id);

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

        public override void Accept(INodeVisitor visitor)
        {
            // emtpy
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("FuncParamSig cannot have child nodes");
        }
    }
}
