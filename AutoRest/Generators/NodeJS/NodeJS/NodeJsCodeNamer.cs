// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.NodeJS
{
    public class NodeJsCodeNamer : CodeNamer
    {
        private readonly HashSet<IType> _normalizedTypes;

        /// <summary>
        /// Initializes a new instance of CSharpCodeNamingFramework.
        /// </summary>
        public NodeJsCodeNamer()
        {
            // List retrieved from
            // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Lexical_grammar#Keywords
            new HashSet<string>
            {
                "array",
                "await",
                "abstract",
                "boolean",
                "buffer",
                "break",
                "byte",
                "case",
                "catch",
                "char",
                "class",
                "const",
                "continue",
                "debugger",
                "default",
                "delete",
                "do",
                "double",
                "date",
                "else",
                "enum",
                "error",
                "export",
                "extends",
                "false",
                "final",
                "finally",
                "float",
                "for",
                "function",
                "goto",
                "if",
                "implements",
                "import",
                "in",
                "int",
                "interface",
                "instanceof",
                "let",
                "long",
                "native",
                "new",
                "null",
                "package",
                "private",
                "protected",
                "public",
                "return",
                "short",
                "static",
                "super",
                "switch",
                "synchronized",
                "this",
                "throw",
                "transient",
                "true",
                "try",
                "typeof",
                "util",
                "var",
                "void",
                "volatile",
                "while",
                "with",
                "yield"
            }.ForEach(s => ReservedWords.Add(s));

            _normalizedTypes = new HashSet<IType>();
        }

        public override string GetFieldName(string name)
        {
            return CamelCase(name);
        }

        public override string GetPropertyName(string name)
        {
            return CamelCase(name);
        }

        public override string GetMethodName(string name)
        {
            name = GetEscapedReservedName(name, "Method");
            return CamelCase(name);
        }

        public override string GetEnumMemberName(string name)
        {
            return CamelCase(name);
        }

        public override string GetParameterName(string name)
        {
            return base.GetParameterName(GetEscapedReservedName(name, "Parameter"));
        }

        public override string GetVariableName(string name)
        {
            return base.GetVariableName(GetEscapedReservedName(name, "Variable"));
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
                    method.Group = method.Group.ToCamelCase();
                }
                var scope = new ScopeProvider();
                foreach (var parameter in method.Parameters)
                {
                    if (parameter.ClientProperty != null)
                    {
                        parameter.Name = string.Format(CultureInfo.InvariantCulture,
                            "{0}.{1}",
                            method.Group == null ? "this" : "this.client",
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

        /// <summary>
        /// Normalize odata filter parameter to PrimaryType.String
        /// </summary>
        /// <param name="client">Service Client</param>
        public void NormalizeOdataFilterParameter(ServiceClient client)
        {
            if (client == null)
            {
                throw new ArgumentNullException("client");
            }

            foreach(var method in client.Methods)
            {
                foreach(var parameter in method.Parameters)
                {
                    if (parameter.SerializedName.Equals("$filter",StringComparison.OrdinalIgnoreCase) &&
                        parameter.Location == ParameterLocation.Query &&
                        parameter.Type is CompositeType)
                    {
                        parameter.Type = PrimaryType.String;
                    }
                }
            }
        }

        /// <summary>
        /// Normalizes the method name if it is a reserved word in javascript.
        /// </summary>
        /// <param name="client">The service client.</param>
        public void NormalizeMethodNames(ServiceClient client)
        {
            if (client == null)
            {
                throw new ArgumentNullException("client");
            }

            foreach (var method in client.Methods)
            {
                method.Name = GetMethodName(method.Name);
            }
        }

        private static IType NormalizeEnumType(EnumType enumType)
        {
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
                primaryType.Name = "Boolean";
            }
            else if (primaryType == PrimaryType.ByteArray)
            {
                primaryType.Name = "Buffer";
            }
            else if (primaryType == PrimaryType.Date)
            {
                primaryType.Name = "Date";
            }
            else if (primaryType == PrimaryType.DateTime)
            {
                primaryType.Name = "Date";
            }
            else if (primaryType == PrimaryType.DateTimeRfc1123)
            {
                primaryType.Name = "Date";
            }
            else if (primaryType == PrimaryType.Double)
            {
                primaryType.Name = "Number";
            }
            else if (primaryType == PrimaryType.Decimal)
            {
                primaryType.Name = "Number";
            }
            else if (primaryType == PrimaryType.Int)
            {
                primaryType.Name = "Number";
            }
            else if (primaryType == PrimaryType.Long)
            {
                primaryType.Name = "Number";
            }
            else if (primaryType == PrimaryType.Stream)
            {
                primaryType.Name = "Object";
            }
            else if (primaryType == PrimaryType.String)
            {
                primaryType.Name = "String";
            }
            else if (primaryType == PrimaryType.TimeSpan)
            {
                primaryType.Name = "moment.duration"; 
            }
            else if (primaryType == PrimaryType.Object)
            {
                primaryType.Name = "Object";
            }

            return primaryType;
        }

        private IType NormalizeSequenceType(SequenceType sequenceType)
        {
            sequenceType.ElementType = NormalizeTypeReference(sequenceType.ElementType);
            sequenceType.NameFormat = "Array";
            return sequenceType;
        }

        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            dictionaryType.ValueType = NormalizeTypeReference(dictionaryType.ValueType);
            dictionaryType.NameFormat = "Object";
            return dictionaryType;
        }
    }
}
