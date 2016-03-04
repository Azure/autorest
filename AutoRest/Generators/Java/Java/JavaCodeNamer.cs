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

        /// <summary>
        /// Skips name collision resolution for method groups (operations) as they get
        /// renamed in template models.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="exclusionDictionary"></param>
        protected override void ResolveMethodGroupNameCollision(ServiceClient serviceClient,
            Dictionary<string, string> exclusionDictionary)
        {
            // Do nothing   
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
                foreach (var parameter in method.Parameters)
                {
                    if (parameter.ClientProperty != null)
                    {
                        parameter.Name = string.Format(CultureInfo.InvariantCulture,
                            "{0}.get{1}()",
                            method.Group == null ? "this" : "this.client",
                            parameter.ClientProperty.Name.ToPascalCase());
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
                type = new PrimaryType(KnownPrimaryType.String);
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
            if (primaryType == null)
            {
                throw new ArgumentNullException("primaryType");
            }

            if (primaryType.Type == KnownPrimaryType.Boolean)
            {
                primaryType.Name = "boolean";
            }
            else if (primaryType.Type == KnownPrimaryType.ByteArray)
            {
                primaryType.Name = "byte[]";
            }
            else if (primaryType.Type == KnownPrimaryType.Date)
            {
                primaryType.Name = "LocalDate";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTime)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123)
            {
                primaryType.Name = "DateTimeRfc1123";
            }
            else if (primaryType.Type == KnownPrimaryType.Double)
            {
                primaryType.Name = "double";
            }
            else if (primaryType.Type == KnownPrimaryType.Decimal)
            {
                primaryType.Name = "BigDecimal";
            }
            else if (primaryType.Type == KnownPrimaryType.Int)
            {
                primaryType.Name = "int";
            }
            else if (primaryType.Type == KnownPrimaryType.Long)
            {
                primaryType.Name = "long";
            }
            else if (primaryType.Type == KnownPrimaryType.Stream)
            {
                primaryType.Name = "InputStream";
            }
            else if (primaryType.Type == KnownPrimaryType.String)
            {
                primaryType.Name = "String";
            }
            else if (primaryType.Type == KnownPrimaryType.TimeSpan)
            {
                primaryType.Name = "Period";
            }
            else if (primaryType.Type == KnownPrimaryType.Uuid)
            {
                primaryType.Name = "UUID";
            }
            else if (primaryType.Type == KnownPrimaryType.Object)
            {
                primaryType.Name = "Object";
            }
            else if (primaryType.Type == KnownPrimaryType.Credentials)
            {
                primaryType.Name = "ServiceClientCredentials";
            }

            return primaryType;
        }

        public static IType WrapPrimitiveType(IType type)
        {
            var primaryType = type as PrimaryType;
            if (primaryType != null)
            {
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

                return primaryType;
            }
            else if (type == null)
            {
                return new PrimaryType(KnownPrimaryType.None)
                {
                    Name = "Void"
                };
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

            if (primaryType.Type == KnownPrimaryType.Date ||
                primaryType.Name == "LocalDate")
            {
                return "org.joda.time.LocalDate";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTime || 
                primaryType.Name == "DateTime")
            {
                return "org.joda.time.DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.Decimal ||
                primaryType.Name == "Decimal")
            {
                return "java.math.BigDecimal";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123 ||
               primaryType.Name == "DateTimeRfc1123")
            {
                return "com.microsoft.rest.DateTimeRfc1123";
            }
            else if (primaryType.Type == KnownPrimaryType.Stream ||
                primaryType.Name == "InputStream")
            {
                return "java.io.InputStream";
            }
            else if (primaryType.Type == KnownPrimaryType.TimeSpan ||
                primaryType.Name == "Period")
            {
                return "org.joda.time.Period";
            }
            else if (primaryType.Type == KnownPrimaryType.Uuid || primaryType.Name == "Uuid")
            {
                return "java.util.UUID";
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

        public override string EscapeDefaultValue(string defaultValue, IType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            var primaryType = type as PrimaryType;
            if (defaultValue != null && primaryType != null)
            {
                if (primaryType.Type == KnownPrimaryType.String)
                {
                    return CodeNamer.QuoteValue(defaultValue);
                }
                else if (primaryType.Type == KnownPrimaryType.Boolean)
                {
                    return defaultValue.ToLowerInvariant();
                }
                else
                {
                    if (primaryType.Type == KnownPrimaryType.Date ||
                        primaryType.Type == KnownPrimaryType.DateTime ||
                        primaryType.Type == KnownPrimaryType.DateTimeRfc1123)
                    {
                        return "DateTime.parse(\"" + defaultValue + "\")";
                    }
                    else if (primaryType.Type == KnownPrimaryType.TimeSpan)
                    {
                        return "Period.parse(\"" + defaultValue + "\")";
                    }
                    else if (primaryType.Type == KnownPrimaryType.ByteArray)
                    {
                        return "\"" + defaultValue + "\".getBytes()";
                    }
                }
            }
            return defaultValue;
        }
    }
}