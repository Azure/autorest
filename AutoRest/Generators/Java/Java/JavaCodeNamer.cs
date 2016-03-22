// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Java.TemplateModels;

namespace Microsoft.Rest.Generator.Java
{
    public class JavaCodeNamer : CodeNamer
    {
        private readonly HashSet<IType> _normalizedTypes;

        public const string ExternalExtension = "x-ms-external";

        public static HashSet<string> PrimaryTypes { get; private set; }

        public static HashSet<string> JavaBuiltInTypes { get; private set; }

        #region constructor

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

        #endregion

        #region naming

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

        #endregion

        #region normalization

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

        /// <summary>
        /// Normalizes the parameter names of a method
        /// </summary>
        /// <param name="method"></param>
        protected override void NormalizeParameters(Method method)
        {
            if (method != null)
            {
                foreach (var parameter in method.Parameters)
                {
                    parameter.Name = method.Scope.GetUniqueName(GetParameterName(parameter.GetClientName()));
                    parameter.Type = NormalizeTypeReference(parameter.Type);
                    QuoteParameter(parameter);
                }

                foreach (var parameterTransformation in method.InputParameterTransformation)
                {
                    parameterTransformation.OutputParameter.Name = method.Scope.GetUniqueName(GetParameterName(parameterTransformation.OutputParameter.GetClientName()));
                    parameterTransformation.OutputParameter.Type = NormalizeTypeReference(parameterTransformation.OutputParameter.Type);

                    QuoteParameter(parameterTransformation.OutputParameter);

                    foreach (var parameterMapping in parameterTransformation.ParameterMappings)
                    {
                        if (parameterMapping.InputParameterProperty != null)
                        {
                            parameterMapping.InputParameterProperty = GetPropertyName(parameterMapping.InputParameterProperty);
                        }

                        if (parameterMapping.OutputParameterProperty != null)
                        {
                            parameterMapping.OutputParameterProperty = GetPropertyName(parameterMapping.OutputParameterProperty);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Normalizes the client properties names of a client model
        /// </summary>
        /// <param name="client">A client model</param>
        protected override void NormalizeClientProperties(ServiceClient client)
        {
            if (client != null)
            {
                foreach (var property in client.Properties)
                {
                    property.Name = GetPropertyName(property.GetClientName());
                    property.Type = NormalizeTypeReference(property.Type);
                    QuoteParameter(property);
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
                property.Name = GetPropertyName(property.GetClientName());
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

        #endregion

        #region type handling

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

        public static IEnumerable<string> ImportPrimaryType(PrimaryType primaryType)
        {
            if (primaryType == null)
            {
                yield break;
            }

            if (primaryType.Type == KnownPrimaryType.Date ||
                primaryType.Name == "LocalDate")
            {
                yield return "org.joda.time.LocalDate";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTime || 
                primaryType.Name == "DateTime")
            {
                yield return "org.joda.time.DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.Decimal ||
                primaryType.Name == "Decimal")
            {
                yield return "java.math.BigDecimal";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123 ||
               primaryType.Name == "DateTimeRfc1123")
            {
                yield return "com.microsoft.rest.DateTimeRfc1123";
                yield return "org.joda.time.DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.Stream ||
                primaryType.Name == "InputStream")
            {
                yield return "java.io.InputStream";
            }
            else if (primaryType.Type == KnownPrimaryType.TimeSpan ||
                primaryType.Name == "Period")
            {
                yield return "org.joda.time.Period";
            }
            else if (primaryType.Type == KnownPrimaryType.Uuid || primaryType.Name == "Uuid")
            {
                yield return "java.util.UUID";
            }
            else
            {
                yield break;
            }
        }

        public virtual List<string> ImportType(IType type, string ns)
        {
            List<string> imports = new List<string>();
            var sequenceType = type as SequenceType;
            var dictionaryType = type as DictionaryType;
            var primaryType = type as PrimaryType;
            var compositeType = type as CompositeType;
            if (sequenceType != null)
            {
                imports.Add("java.util.List");
                imports.AddRange(ImportType(sequenceType.ElementType, ns));
            }
            else if (dictionaryType != null)
            {
                imports.Add("java.util.Map");
                imports.AddRange(ImportType(dictionaryType.ValueType, ns));
            }
            else if (compositeType != null && ns != null)
            {
                if (type.Name.Contains('<'))
                {
                    imports.AddRange(compositeType.ParseGenericType().SelectMany(t => ImportType(t, ns)));
                }
                else if (compositeType.Extensions.ContainsKey(ExternalExtension) &&
                    (bool)compositeType.Extensions[ExternalExtension])
                {
                    imports.Add(string.Join(
                        ".",
                        "com.microsoft.rest",
                        type.Name));
                }
                else
                {
                    imports.Add(string.Join(
                        ".",
                        ns.ToLower(CultureInfo.InvariantCulture),
                        "models",
                        type.Name));
                }
            }
            else if (type is EnumType && ns != null)
            {
                imports.Add(string.Join(
                    ".",
                    ns.ToLower(CultureInfo.InvariantCulture),
                    "models",
                    type.Name));
            }
            else if (primaryType != null)
            {
                var importedFrom = JavaCodeNamer.ImportPrimaryType(primaryType);
                if (importedFrom != null)
                {
                    imports.AddRange(importedFrom);
                }
            }
            return imports;
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

        #endregion

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
                else if (primaryType.Type == KnownPrimaryType.Long)
                {
                    return defaultValue + "L";
                }
                else
                {
                    if (primaryType.Type == KnownPrimaryType.Date)
                    {
                        return "LocalDate.parse(\"" + defaultValue + "\")";
                    }
                    else if (primaryType.Type == KnownPrimaryType.DateTime ||
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