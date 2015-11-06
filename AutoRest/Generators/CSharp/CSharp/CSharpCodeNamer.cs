// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.CSharp
{
    public class CSharpCodeNamer : CodeNamer
    {
        private readonly HashSet<IType> _normalizedTypes;

        /// <summary>
        /// Initializes a new instance of CSharpCodeNamingFramework.
        /// </summary>
        public CSharpCodeNamer()
        {
            new HashSet<string>
            {
                "abstract", "as",       "async",      "await",     "base",
                "bool",     "break",    "byte",       "case",      "catch",
                "char",     "checked",  "class",      "const",     "continue",
                "decimal",  "default",  "delegate",   "do",        "double",
                "dynamic",  "else",     "enum",       "event",     "explicit",
                "extern",   "false",    "finally",    "fixed",     "float",
                "for",      "foreach",  "from",       "global",    "goto",
                "if",       "implicit", "in",         "int",       "interface",
                "internal", "is",       "lock",       "long",      "namespace",
                "new",      "null",     "object",     "operator",  "out",
                "override", "params",   "private",    "protected", "public",
                "readonly", "ref",      "return",     "sbyte",     "sealed",
                "short",    "sizeof",   "stackalloc", "static",    "string",
                "struct",   "switch",   "this",       "throw",     "true",
                "try",      "typeof",   "uint",       "ulong",     "unchecked",
                "unsafe",   "ushort",   "using",       "virtual",  "void",
                "volatile", "while",    "yield",       "var"
            }.ForEach(s => ReservedWords.Add(s));

            _normalizedTypes = new HashSet<IType>();
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
                var scope = new ScopeProvider();
                foreach (var parameter in method.Parameters)
                {
                    if (parameter.ClientProperty != null)
                    {
                        parameter.Name = string.Format(CultureInfo.InvariantCulture,
                            "{0}.{1}",
                            method.Group == null ? "this" : "this.Client",
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
            if (type == null)
            {
                return null;
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

        protected virtual IType NormalizePrimaryType(PrimaryType primaryType)
        {
            if (primaryType == null)
            {
                return null;
            }

            if (primaryType == PrimaryType.Boolean)
            {
                primaryType.Name = "bool?";
            }
            else if (primaryType == PrimaryType.ByteArray)
            {
                primaryType.Name = "byte[]";
            }
            else if (primaryType == PrimaryType.Date)
            {
                primaryType.Name = "DateTime?";
            }
            else if (primaryType == PrimaryType.DateTime)
            {
                primaryType.Name = "DateTime?";
            }
            else if (primaryType == PrimaryType.DateTimeRfc1123)
            {
                primaryType.Name = "DateTime?";
            }
            else if (primaryType == PrimaryType.Double)
            {
                primaryType.Name = "double?";
            }
            else if (primaryType == PrimaryType.Decimal)
            {
                primaryType.Name = "decimal?";
            }
            else if (primaryType == PrimaryType.Int)
            {
                primaryType.Name = "int?";
            }
            else if (primaryType == PrimaryType.Long)
            {
                primaryType.Name = "long?";
            }
            else if (primaryType == PrimaryType.Stream)
            {
                primaryType.Name = "System.IO.Stream";
            }
            else if (primaryType == PrimaryType.String)
            {
                primaryType.Name = "string";
            }
            else if (primaryType == PrimaryType.TimeSpan)
            {
                primaryType.Name = "TimeSpan?";
            }
            else if (primaryType == PrimaryType.Object)
            {
                primaryType.Name = "object";
            }
            else if (primaryType == PrimaryType.Credentials)
            {
                primaryType.Name = "ServiceClientCredentials";
            }

            return primaryType;
        }

        public override IType NormalizeTypeReference(IType type)
        {
            var enumType = type as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                return PrimaryType.String;
            }
            return NormalizeTypeDeclaration(type);
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

        private IType NormalizeEnumType(EnumType enumType)
        {
            enumType.Name = GetTypeName(enumType.Name) + "?";

            for (int i = 0; i < enumType.Values.Count; i++)
            {
                enumType.Values[i].Name = GetEnumMemberName(enumType.Values[i].Name);
            }
            return enumType;
        }        

        private IType NormalizeSequenceType(SequenceType sequenceType)
        {
            sequenceType.ElementType = NormalizeTypeReference(sequenceType.ElementType);
            sequenceType.NameFormat = "IList<{0}>";
            return sequenceType;
        }

        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            dictionaryType.ValueType = NormalizeTypeReference(dictionaryType.ValueType);
            dictionaryType.NameFormat = "IDictionary<string, {0}>";
            return dictionaryType;
        }
    }
}
