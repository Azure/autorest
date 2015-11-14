// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Python
{
    public class PythonCodeNamer : CodeNamer
    {
        private readonly HashSet<IType> _normalizedTypes;

        /// <summary>
        /// Initializes a new instance of CSharpCodeNamingFramework.
        /// </summary>
        public PythonCodeNamer()
        {
            // List retrieved from
            // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
            new HashSet<string>
            {
                "and",
                "as",
                "assert",
                "break",
                "class",
                "continue",
                "def",
                "del",
                "elif",
                "else",
                "except",
                "exec",
                "finally",
                "for",
                "from",
                "global",
                "if",
                "import",
                "in",
                "is",
                "lambda",
                "not",
                "or",
                "pass",
                "print",
                "raise",
                "return",
                "try",
                "while",
                "with",
                "yield",
                // Though the following word is not python keyword, but it will cause trouble if we use them as variable, field, etc.
                "int",
                "bool",
                "bytearray",
                "date",
                "datetime",
                "float",
                "long",
                "object",
                "Decimal",
                "str",
                "timedelta"

            }.ForEach(s => ReservedWords.Add(s));

            _normalizedTypes = new HashSet<IType>();
        }

        /// <summary>
        /// Removes invalid characters from the name.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <param name="allowerCharacters">Allowed characters.</param>
        /// <returns>Name with invalid characters removed.</returns>
        private static string RemoveInvalidCharacters(string name, params char[] allowerCharacters)
        {
            return new string(name.Replace("[]", "Sequence")
                   .Where(c => char.IsLetterOrDigit(c) || allowerCharacters.Contains(c))
                   .ToArray());
        }

        private string GetValidPythonName(string name, string padString)
        {
            return PythonCase(GetEscapedReservedName(RemoveInvalidPythonCharacters(name), padString));
        }

        public override string GetFieldName(string name)
        {
            return "_" + GetValidPythonName(name, "Variable");
        }

        public override string GetPropertyName(string name)
        {
            return GetValidPythonName(name, "Property");
        }

        public override string GetMethodName(string name)
        {
            return GetValidPythonName(name, "Method");
        }

        public override string GetEnumMemberName(string name)
        {
            return GetValidPythonName(name, "Enum");
        }

        public override string GetParameterName(string name)
        {
            return GetValidPythonName(name, "Parameter");
        }

        public override string GetVariableName(string name)
        {
            return GetValidPythonName(name, "Variable");
        }

        public override void NormalizeClientModel(ServiceClient client)
        {
            if (client == null)
            {
                throw new ArgumentNullException("client");
            }

            base.NormalizeClientModel(client);
            foreach (var method in client.Methods)
            {
                if (method.Group != null)
                {
                    method.Group = method.Group.ToPythonCase();
                }
                var scope = new ScopeProvider();
                foreach (var parameter in method.Parameters)
                {
                    if (parameter.ClientProperty != null)
                    {
                        parameter.Name = string.Format(CultureInfo.InvariantCulture,
                            "self.config.{0}",
                            parameter.ClientProperty.Name);
                    }
                    else
                    {
                        parameter.Name = scope.GetVariableName(parameter.Name);
                    }
                }
            }
        }

        public override IType NormalizeTypeDeclaration(IType type)
        {
            return NormalizeTypeReference(type);
        }

        public override IType NormalizeTypeReference(IType type)
        {
            if (type == null)
            {
                return null;
            }
            var enumType = type as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                type = PrimaryType.String;
            }

            // Using Any instead of Contains since object hash is bound to a property which is modified during normalization
            if (_normalizedTypes.Any(item => type.Equals(item)))
            {
                return _normalizedTypes.First(item => type.Equals(item));
            }

            _normalizedTypes.Add(type);
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


            throw new NotSupportedException(string.Format(CultureInfo.InvariantCulture,
                "Type {0} is not supported.", type.GetType()));
        }

        private IType NormalizeEnumType(EnumType enumType)
        {
            for (int i = 0; i < enumType.Values.Count; i++)
            {
                enumType.Values[i].Name = GetEnumMemberName(enumType.Values[i].Name);
            }
            return enumType;
        }

        private IType NormalizeCompositeType(CompositeType compositeType)
        {
            compositeType.Name = GetTypeName(compositeType.Name);

            foreach (var property in compositeType.Properties)
            {
                property.Name = GetPropertyName(property.Name);
                property.Type = NormalizeTypeReference(property.Type);
            }

            return compositeType;
        }

        private static IType NormalizePrimaryType(PrimaryType primaryType)
        {
            if (primaryType == PrimaryType.Boolean)
            {
                primaryType.Name = "bool";
            }
            else if (primaryType == PrimaryType.ByteArray)
            {
                primaryType.Name = "bytearray";
            }
            else if (primaryType == PrimaryType.Date)
            {
                primaryType.Name = "date";
            }
            else if (primaryType == PrimaryType.DateTime)
            {
                primaryType.Name = "datetime";
            }
            else if (primaryType == PrimaryType.DateTimeRfc1123)
            {
                primaryType.Name = "datetime";
            }
            else if (primaryType == PrimaryType.Double)
            {
                primaryType.Name = "float";
            }
            else if (primaryType == PrimaryType.Int)
            {
                primaryType.Name = "int";
            }
            else if (primaryType == PrimaryType.Long)
            {
                primaryType.Name = "long";
            }
            else if (primaryType == PrimaryType.Stream)  // Revisit here
            {
                primaryType.Name = "Object";
            }
            else if (primaryType == PrimaryType.String)
            {
                primaryType.Name = "str";
            }
            else if (primaryType == PrimaryType.TimeSpan)
            {
                primaryType.Name = "timedelta"; 
            }
            else if (primaryType == PrimaryType.Decimal)
            {
                primaryType.Name = "Decimal";
            }
            else if (primaryType == PrimaryType.Object)  // Revisit here
            {
                primaryType.Name = "object";
            }

            return primaryType;
        }

        private IType NormalizeSequenceType(SequenceType sequenceType)
        {
            sequenceType.ElementType = NormalizeTypeReference(sequenceType.ElementType);
            sequenceType.NameFormat = "list";
            return sequenceType;
        }

        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            dictionaryType.ValueType = NormalizeTypeReference(dictionaryType.ValueType);
            dictionaryType.NameFormat = "dict";
            return dictionaryType;
        }
    }
}
