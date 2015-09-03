// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Microsoft.Rest.Generator.Java
{
    public class JavaCodeNamer : CodeNamer
    {
        private readonly HashSet<IType> _normalizedTypes;

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
                "period",   "stream",   "string",   "object"
            }.ForEach(s => ReservedWords.Add(s));

            _normalizedTypes = new HashSet<IType>();
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
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            name = GetEscapedReservedName(name, "Operations");
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

        public override IType NormalizeType(IType type)
        {
            if (type == null)
            {
                return null;
            }
            var enumType = type as EnumType;
            if (enumType != null && enumType.IsExpandable)
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
            if (enumType.IsExpandable)
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
                property.Type = NormalizeType(property.Type);
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
            else if (primaryType == PrimaryType.Double)
            {
                primaryType.Name = "double";
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
            sequenceType.ElementType = WrapPrimitiveType(NormalizeType(sequenceType.ElementType));
            sequenceType.NameFormat = "List<{0}>";
            return sequenceType;
        }

        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            dictionaryType.ValueType = WrapPrimitiveType(NormalizeType(dictionaryType.ValueType));
            dictionaryType.NameFormat = "Map<String, {0}>";
            return dictionaryType;
        }

        public static String ImportedFrom(PrimaryType primaryType)
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
            else if (primaryType == PrimaryType.Stream ||
                primaryType.Name == "InputStream")
            {
                return "java.io.InputStream";
            }
            else if (primaryType == PrimaryType.TimeSpan ||
                primaryType.Name == "Period")
            {
                return "java.time.Period";
            }
            else
            {
                return null;
            }
        }
    }
}