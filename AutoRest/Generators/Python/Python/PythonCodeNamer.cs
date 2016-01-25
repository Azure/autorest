// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Python.TemplateModels;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using Microsoft.Rest.Generator.Python.Properties;

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

        // "joined_lower" for functions, methods, attributes
        // do not invoke this for a class name which should be "StudlyCaps"
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        public static string PythonCase(string name)
        {
            name = Regex.Replace(name, @"[A-Z]+", m =>
            {
                string matchedStr = m.ToString().ToLowerInvariant();
                if (m.Index > 0 && name[m.Index - 1] == '_')
                {
                    //we are good if a '_' already exists 
                    return matchedStr;
                }
                else
                {
                    // The first letter should not have _
                    string prefix = m.Index > 0 ? "_" : string.Empty;
                    if (ShouldInsertExtraLowerScoreInTheMiddle(name, m, matchedStr))
                    {
                        // We will add extra _ if there are multiple capital chars together
                        return prefix + matchedStr.Substring(0, matchedStr.Length - 1) + "_" + matchedStr.Substring(matchedStr.Length - 1);
                    }
                    else
                    {
                        return prefix + matchedStr;
                    }
                }
            });
            return name;
        }

        private static bool ShouldInsertExtraLowerScoreInTheMiddle(string name, Match m, string matchedStr)
        {
            //For name like "SQLConnection", we will insert an extra '_' between "SQL" and "Connection"
            //we will only insert if there are more than 2 consecutive upper cases, because 2 upper cases
            //most likely means one single word. 
            int nextNonUpperCaseCharLocation = m.Index + matchedStr.Length;
            return matchedStr.Length > 2 && nextNonUpperCaseCharLocation < name.Length && char.IsLetter(name[nextNonUpperCaseCharLocation]);
        }

        /// <summary>
        /// Removes invalid characters from the name. Everything but alpha-numeral, underscore.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <returns>Name with invalid characters removed.</returns>
        public static string RemoveInvalidPythonCharacters(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, Resources.InvalidIdentifierName, name));
            }

            return GetValidName(name.Replace('-', '_'), '_');
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
                //if (method.Group != null)
                //{
                //    method.Group = method.Group.ToPythonCase();
                //}
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
            if (enumType != null && enumType.Name.Length == 0 && enumType.ModelAsString)
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
