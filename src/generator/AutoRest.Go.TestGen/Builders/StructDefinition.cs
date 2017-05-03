// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Represents a struct field definition.
    /// </summary>
    public struct StructFieldDef
    {
        /// <summary>
        /// Name of the field.
        /// </summary>
        public string Name;

        /// <summary>
        /// The field's type.
        /// </summary>
        public string TypeName;

        /// <summary>
        /// Optional tag.
        /// </summary>
        public string Tag;

        /// <summary>
        /// Initializes StructFieldDef with the specified values.
        /// </summary>
        /// <param name="name">The name of the field.</param>
        /// <param name="typeName">The type name of the field.</param>
        /// <param name="tag">Optional tag for the field.</param>
        public StructFieldDef(string name, string typeName, string tag)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException(nameof(name));
            }

            if (string.IsNullOrWhiteSpace(typeName))
            {
                throw new ArgumentException(nameof(typeName));
            }

            Name = name;
            TypeName = typeName;
            Tag = tag;
        }
    }

    /// <summary>
    /// Generates struct definitions.
    /// </summary>
    public static class StructDefinition
    {
        /// <summary>
        /// Generates a struct definition with the specified name and fields.
        /// If the struct is to contain no fields pass null for the fields parameter.
        /// </summary>
        /// <param name="name">The name of the struct to be created.</param>
        /// <param name="fields">Optional list of fields.  Pass null if the struct has no fields.</param>
        /// <returns>Root node for this struct definition's AST.</returns>
        public static Node Generate(string name, IReadOnlyList<StructFieldDef> fields)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException(nameof(name));
            }

            if (fields != null && fields.Count == 0)
            {
                throw new ArgumentException("pass null for no struct fields");
            }

            var typeDef = new TypeDef();
            typeDef.AddChild(new Identifier(name));

            var structDef = new StructDef();
            var defStart = new OpenDelimiter(BinaryDelimiterType.Brace);

            if (fields != null)
            {
                foreach (var field in fields)
                {
                    var id = new Identifier(field.Name);
                    id.AddChild(new TypeName(field.TypeName));

                    if (field.Tag != null)
                    {
                        id.AddChild(new Tag(field.Tag));
                    }

                    defStart.AddChild(id);
                }
            }

            defStart.AddClosingDelimiter();
            structDef.AddChild(defStart);

            typeDef.AddChild(structDef);
            return typeDef;
        }
    }
}
