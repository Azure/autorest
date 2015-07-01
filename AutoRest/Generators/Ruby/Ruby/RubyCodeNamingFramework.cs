// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    using System.Text.RegularExpressions;

    public class RubyCodeNamingFramework : CodeNamer
    {
        private readonly HashSet<IType> normalizedTypes;

        /// <summary>
        /// Initializes a new instance of RubyCodeNamingFramework.
        /// </summary>
        public RubyCodeNamingFramework()
        {
            new HashSet<string>
            {
                "begin",    "do",       "next",     "then",     "end",
                "else",     "nil",      "true",     "alias",    "elsif",
                "not",      "undef",    "and",      "end",      "or",
                "unless",   "begin",    "ensure",   "redo",     "until",
                "break",    "false",    "rescue",   "when",     "case",
                "for",      "retry",    "while",    "class",    "if",
                "return",   "while",    "def",      "in",       "self",   
                "__file__", "defined?", "module",   "super",    "__line__",
                "yield"
            }.ForEach(s => ReservedWords.Add(s));

            normalizedTypes = new HashSet<IType>();
        }

        /// <summary>
        /// Formats segments of a string into "underscore" case.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public static string UnderscoreCase(string name)
        {
            return Regex.Replace(name, @"(\p{Ll})(\p{Lu})", "$1_$2").ToLower();
        }

        /// <summary>
        /// Corrects characters for Ruby compatibility.
        /// </summary>
        /// <param name="name">String to correct.</param>
        /// <returns>Corrected string.</returns>
        public string RubyRemoveInvalidCharacters(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                return name;
            }

            return RemoveInvalidCharacters(name).Replace('-', '_');
        }

        public override string GetMethodName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Operation")));
        }

        public override string GetFieldName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return GetVariableName(name);
        }

        public override string GetPropertyName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Property")));
        }

        public override string GetVariableName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Variable")));
        }

        public override void NormalizeClientModel(ServiceClient client)
        {
            base.NormalizeClientModel(client);
            foreach (var method in client.Methods)
            {
                var scope = new ScopeProvider();
                foreach (var parameter in method.Parameters)
                {
                    parameter.Name = scope.GetVariableName(parameter.Name);
                    parameter.SetRequiredOptional();
                }
            }
        }

        protected override IType NormalizeType(IType type)
        {
            if (type == null)
            {
                return null;
            }
            // Using Any instead of Contains since object hash is bound to a property which is modified during normalization
            if (normalizedTypes.Any(item => type.Equals(item)))
            {
                return normalizedTypes.First(item => type.Equals(item));
            }

            normalizedTypes.Add(type);
            if (type is PrimaryType)
            {
                return NormalizePrimaryType(type as PrimaryType);
            }

            if (type is SequenceType)
            {
                return NormalizeSequenceType(type as SequenceType);
            }

            if (type is DictionaryType)
            {
                return NormalizeDictionaryType(type as DictionaryType);
            }

            if (type is CompositeType)
            {
                return NormalizeCompositeType(type as CompositeType);
            }

            if (type is EnumType)
            {
                return NormalizeEnumType(type as EnumType);
            }

            throw new NotSupportedException(string.Format("Type {0} is not supported.", type.GetType()));
        }

        private IType NormalizeCompositeType(CompositeType compositeType)
        {
            compositeType.SerializedName = compositeType.Name;
            compositeType.Name = GetTypeName(compositeType.Name);

            foreach (var property in compositeType.Properties)
            {
                property.SerializedName = property.Name;
                property.Name = GetPropertyName(property.Name);
                property.Type = NormalizeType(property.Type);
            }

            return compositeType;
        }

        private IType NormalizeEnumType(EnumType enumType)
        {   
            for (int i = 0; i < enumType.Values.Count; i++)
            {
                if (enumType.Values[i].Name != null)
                {
                    enumType.Values[i].SerializedName = RubyRemoveInvalidCharacters(enumType.Values[i].Name);
                }
                
                enumType.Values[i].Name = GetEnumMemberName(enumType.Values[i].Name);
            }

            return enumType;
        }

        private IType NormalizePrimaryType(PrimaryType primaryType)
        {
            if (primaryType == PrimaryType.Boolean)
            {
                primaryType.Name = "Boolean";
            }
            else if (primaryType == PrimaryType.ByteArray)
            {
                primaryType.Name = "Array";
            }
            else if (primaryType == PrimaryType.DateTime)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType == PrimaryType.Double)
            {
                primaryType.Name = "Float";
            }
            else if (primaryType == PrimaryType.Int)
            {
                primaryType.Name = "Number";
            }
            else if (primaryType == PrimaryType.Long)
            {
                primaryType.Name = "Bignum";
            }
            else if (primaryType == PrimaryType.Stream)
            {
                //TODO: verify this
                primaryType.Name = "System.IO.Stream";
            }
            else if (primaryType == PrimaryType.String)
            {
                primaryType.Name = "String";
            }
            else if (primaryType == PrimaryType.TimeSpan)
            {
                primaryType.Name = "Duration";
            }
            else if (primaryType == PrimaryType.Object)
            {
                primaryType.Name = "Object";
            }

            return primaryType;
        }

        private IType NormalizeSequenceType(SequenceType sequenceType)
        {
            sequenceType.ElementType = NormalizeType(sequenceType.ElementType);
            sequenceType.NameFormat = "Array";
            return sequenceType;
        }

        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            dictionaryType.ValueType = NormalizeType(dictionaryType.ValueType);
            dictionaryType.NameFormat = "Hash";
            return dictionaryType;
        }
    }
}