// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Represents a struct field name/value pair.
    /// </summary>
    public struct StructField
    {
        public string FieldName;
        public Node Value;

        /// <summary>
        /// Initializes StructField with the specified values.
        /// </summary>
        /// <param name="fieldName">The struct field name.</param>
        /// <param name="value">The value for the field.</param>
        public StructField(string fieldName, Node value)
        {
            if (string.IsNullOrWhiteSpace(fieldName))
            {
                throw new ArgumentException(nameof(fieldName));
            }

            if (value == null)
            {
                throw new ArgumentNullException(nameof(value));
            }

            FieldName = fieldName;
            Value = value;
        }
    }

    /// <summary>
    /// Generates struct literals.
    /// </summary>
    public static class StructLiteral
    {
        /// <summary>
        /// Generates a struct literal of the specified type name and optional field values.
        /// </summary>
        /// <param name="structTypeName">The fully qualified struct type name.</param>
        /// <param name="values">Optional field values.  Pass null to omit field initialization.</param>
        /// <returns>The root node in this struct literal AST.</returns>
        public static Node Generate(string structTypeName, IEnumerable<StructField> values)
        {
            if (string.IsNullOrWhiteSpace(structTypeName))
            {
                throw new ArgumentException(nameof(structTypeName));
            }

            if (values != null && !values.Any())
            {
                throw new ArgumentException("pass null to omit struct field initializers");
            }

            var id = new Identifier(structTypeName);
            var openBrace = new OpenDelimiter(BinaryDelimiterType.Brace);

            if (values != null)
            {
                var initList = new List<Node>();
                foreach (var val in values)
                {
                    var root = DelimitedSequence.Generate(UnaryDelimiterType.Colon, new[]
                    {
                        new Identifier(val.FieldName),
                        val.Value
                    });

                    initList.Add(root);
                }

                var seqRoot = DelimitedSequence.Generate(UnaryDelimiterType.Comma, initList, true);
                openBrace.AddChild(seqRoot);
            }

            openBrace.AddClosingDelimiter();
            id.AddChild(openBrace);

            return id;
        }
    }
}
