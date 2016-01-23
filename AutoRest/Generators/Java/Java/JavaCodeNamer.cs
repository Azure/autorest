// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
{
    public class JavaCodeNamer : CodeNamer
    {
        private readonly HashSet<IType> _normalizedTypes;

        public static HashSet<string> PrimaryTypes { get; private set; }

        public static HashSet<string> JavaBuiltInTypes { get; private set; }

        /// <summary>
        /// Initializes a new instance of CSharpCodeNamingFramework.
        /// </summary>
        public JavaCodeNamer()
        {
            // List retrieved from 
            // http://docs.oracle.com/javase/tutorial/java/nutsandbolts/_keywords.html
            new HashSet<string>
            {
                "abstract", "assert",   "boolean",  "break",    "byte",
                "case",     "catch",    "char",     "class",    "const",
                "continue", "default",  "do",       "double",   "else",
                "enum",     "extends",  "false",    "final",    "finally",
                "float",    "for",      "goto",     "if",       "implements",
                "import",   "int",      "long",     "interface","instanceof",
                "native",   "new",      "null",     "package",  "private",
                "protected","public",   "return",   "short",    "static",
                "strictfp", "super",    "switch",   "synchronized","this",
                "throw",    "throws",   "transient","true",     "try",
                "void",     "volatile", "while",    "date",     "datetime",
                "period",   "stream",   "string",   "object", "header"
            }.ForEach(s => ReservedWords.Add(s));

            _normalizedTypes = new HashSet<IType>();
            PrimaryTypes = new HashSet<string>();
            new HashSet<string>
            {
                "int", "Integer",
                "long", "Long",
                "object", "Object",
                "bool", "Boolean",
                "double", "Double",
                "float", "Float",
                "byte", "Byte",
                "byte[]", "Byte[]",
                "String",
                "LocalDate",
                "DateTime",
                "DateTimeRfc1123",
                "Duration",
                "Period",
                "BigDecimal",
                "InputStream"
            }.ForEach(s => PrimaryTypes.Add(s));
            JavaBuiltInTypes = new HashSet<string>();
            new HashSet<string>
            {
                "int",
                "long",
                "bool",
                "double",
                "float",
                "byte",
                "byte[]"
            }.ForEach(s => PrimaryTypes.Add(s));
        }

        public override string GetFieldName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return '_' + GetVariableName(name);
        }

        public override string GetPropertyName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return CamelCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Property")));
        }

        public override string GetMethodName(string name)
        {
            name = GetEscapedReservedName(name, "Method");
            return CamelCase(name);
        }
        
        public override string GetMethodGroupName(string name)
        {
            return PascalCase(name);
        }

        public override string GetEnumMemberName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return RemoveInvalidCharacters(new Regex("[\\ -]+").Replace(name, "_")).ToUpper(CultureInfo.InvariantCulture);
        }

        public override string GetParameterName(string name)
        {
            return base.GetParameterName(GetEscapedReservedName(name, "Parameter"));
        }

        public override string GetVariableName(string name)
        {
            return base.GetVariableName(GetEscapedReservedName(name, "Variable"));
        }

        public static string GetServiceName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return name + "Service";
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
                            "{0}.get{1}()",
                            method.Group == null ? "this" : "this.client",
                            parameter.ClientProperty.Name.ToPascalCase());
                    }
                    else
                    {
                        parameter.Name = scope.GetVariableName(parameter.Name);
                    }

                    if (!parameter.IsRequired)
                    {
                        parameter.Type = WrapPrimitiveType(parameter.Type);
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
            if (enumType.ModelAsString)
            {
                enumType.SerializedName = "string";
                enumType.Name = "string";
            }
            else
            {
                enumType.Name = GetTypeName(enumType.Name);
            }
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
                if (!property.IsRequired)
                {
                    property.Type = WrapPrimitiveType(property.Type);
                }
            }

            return compositeType;
        }

        private static PrimaryType NormalizePrimaryType(PrimaryType primaryType)
        {
            if (primaryType == PrimaryType.Boolean)
            {
                primaryType.Name = "boolean";
            }
            else if (primaryType == PrimaryType.ByteArray)
            {
                primaryType.Name = "byte[]";
            }
            else if (primaryType == PrimaryType.Date)
            {
                primaryType.Name = "LocalDate";
            }
            else if (primaryType == PrimaryType.DateTime)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType == PrimaryType.DateTimeRfc1123)
            {
                primaryType.Name = "DateTimeRfc1123";
            }
            else if (primaryType == PrimaryType.Double)
            {
                primaryType.Name = "double";
            }
            else if (primaryType == PrimaryType.Decimal)
            {
                primaryType.Name = "BigDecimal";
            }
            else if (primaryType == PrimaryType.Int)
            {
                primaryType.Name = "int";
            }
            else if (primaryType == PrimaryType.Long)
            {
                primaryType.Name = "long";
            }
            else if (primaryType == PrimaryType.Stream)
            {
                primaryType.Name = "InputStream";
            }
            else if (primaryType == PrimaryType.String)
            {
                primaryType.Name = "String";
            }
            else if (primaryType == PrimaryType.TimeSpan)
            {
                primaryType.Name = "Period";
            }
            else if (primaryType == PrimaryType.Object)
            {
                primaryType.Name = "Object";
            }
            else if (primaryType == PrimaryType.Credentials)
            {
                primaryType.Name = "ServiceClientCredentials";
            }

            return primaryType;
        }

        public static IType WrapPrimitiveType(IType type)
        {
            if (type is PrimaryType)
            {
                var primaryType = new PrimaryType();
                if (type.Name == "boolean")
                {
                    primaryType.Name = "Boolean";
                }
                else if (type.Name == "double")
                {
                    primaryType.Name = "Double";
                }
                else if (type.Name == "int")
                {
                    primaryType.Name = "Integer";
                }
                else if (type.Name == "long")
                {
                    primaryType.Name = "Long";
                }
                else
                {
                    return type;
                }
                return primaryType;
            }
            else if (type == null)
            {
                var newType = new PrimaryType();
                newType.Name = "Void";
                return newType;
            }
            else
            {
                return type;
            }
        }

        private IType NormalizeSequenceType(SequenceType sequenceType)
        {
            sequenceType.ElementType = WrapPrimitiveType(NormalizeTypeReference(sequenceType.ElementType));
            sequenceType.NameFormat = "List<{0}>";
            return sequenceType;
        }

        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            dictionaryType.ValueType = WrapPrimitiveType(NormalizeTypeReference(dictionaryType.ValueType));
            dictionaryType.NameFormat = "Map<String, {0}>";
            return dictionaryType;
        }

        public static string GetJavaType(PrimaryType primaryType)
        {
            if (primaryType == null)
            {
                return null;
            }

            if (primaryType == PrimaryType.Date ||
                primaryType.Name == "LocalDate")
            {
                return "org.joda.time.LocalDate";
            }
            else if (primaryType == PrimaryType.DateTime || 
                primaryType.Name == "DateTime")
            {
                return "org.joda.time.DateTime";
            }
            else if (primaryType == PrimaryType.Decimal ||
                primaryType.Name == "Decimal")
            {
                return "java.math.BigDecimal";
            }
            else if (primaryType == PrimaryType.DateTimeRfc1123 ||
               primaryType.Name == "DateTimeRfc1123")
            {
                return "com.microsoft.rest.DateTimeRfc1123";
            }
            else if (primaryType == PrimaryType.Stream ||
                primaryType.Name == "InputStream")
            {
                return "java.io.InputStream";
            }
            else if (primaryType == PrimaryType.TimeSpan ||
                primaryType.Name == "Period")
            {
                return "org.joda.time.Period";
            }
            else
            {
                return null;
            }
        }

        public static string GetJavaException(string exception, ServiceClient serviceClient)
        {
            switch (exception) {
                case "IOException":
                    return "java.io.IOException";
                case "ServiceException":
                    return "com.microsoft.rest.ServiceException";
                case "CloudException":
                    return "com.microsoft.azure.CloudException";
                case "AutoRestException":
                    return "com.microsoft.rest.AutoRestException";
                case "IllegalArgumentException":
                    return null;
                case "InterruptedException":
                    return null;
                default:
                    return serviceClient.Namespace.ToLower(CultureInfo.InvariantCulture)
                        + ".models." + exception;
            }
        }
    }
}