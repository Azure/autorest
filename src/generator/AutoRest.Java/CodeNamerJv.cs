// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;
using AutoRest.Core;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Core.Model;
using AutoRest.Java.Model;

namespace AutoRest.Java
{
    public class CodeNamerJv : CodeNamer
    {
        private Dictionary<IModelType, IModelType> _visited = new Dictionary<IModelType, IModelType>();

        public const string ExternalExtension = "x-ms-external";

        public static HashSet<string> PrimaryTypes { get; private set; }

        public static HashSet<string> JavaBuiltInTypes { get; private set; }
        
        #region constructor

        /// <summary>
        /// Initializes a new instance of CSharpCodeNamingFramework.
        /// </summary>
        public CodeNamerJv()
        {
            // List retrieved from 
            // http://docs.oracle.com/javase/tutorial/java/nutsandbolts/_keywords.html
            ReservedWords.AddRange(new []
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
            });

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

        ///// <summary>
        ///// Resolves name collisions in the client model for method groups (operations).
        ///// </summary>
        ///// <param name="serviceClient"></param>
        ///// <param name="exclusionDictionary"></param>
        //protected override void ResolveMethodGroupNameCollision(CodeModel serviceClient,
        //    Dictionary<string, string> exclusionDictionary)
        //{
        //    // do nothing
        //}

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
            name = PascalCase(name);
            if (!name.EndsWith("s", StringComparison.OrdinalIgnoreCase))
            {
                name += "s";
            }
            return name;
        }

        public override string GetEnumMemberName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            string result = RemoveInvalidCharacters(new Regex("[\\ -]+").Replace(name, "_"));
            Func<char, bool> isUpper = new Func<char, bool>(c => c >= 'A' && c <= 'Z');
            Func<char, bool> isLower = new Func<char, bool>(c => c >= 'a' && c <= 'z');
            for (int i = 1; i < result.Length - 1; i++)
            {
                if (isUpper(result[i]))
                {
                    if (result[i - 1] != '_' && isLower(result[i - 1]))
                    {
                        result = result.Insert(i, "_");
                    }
                }
            }
            return result.ToUpper(CultureInfo.InvariantCulture);
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
        
        //public override void NormalizeClientModel(CodeModel client)
        //{
        //    if (client == null)
        //    {
        //        throw new ArgumentNullException("client");
        //    }

        //    base.NormalizeClientModel(client);
        //    foreach (var method in client.Methods)
        //    {
        //        if (method.Group != null)
        //        {
        //            method.Group = method.Group.ToCamelCase();
        //        }
        //        foreach (var parameter in method.Parameters)
        //        {
        //            if (parameter.ClientProperty != null)
        //            {
        //                parameter.Name = string.Format(CultureInfo.InvariantCulture,
        //                    "{0}.{1}()",
        //                    method.Group == null ? "this" : "this.client",
        //                    parameter.ClientProperty.Name.ToCamelCase());
        //            }

        //            if (!parameter.IsRequired)
        //            {
        //                parameter.Type = WrapPrimitiveType(parameter.Type);
        //            }
        //        }
        //    }
        //}

        ///// <summary>
        ///// Normalizes the parameter names of a method
        ///// </summary>
        ///// <param name="method"></param>
        //protected override void NormalizeParameters(Method method)
        //{
        //    if (method != null)
        //    {
        //        foreach (var parameter in method.Parameters)
        //        {
        //            parameter.Name = method.Scope.GetUniqueName(GetParameterName(parameter.GetClientName()));
        //            parameter.Type = NormalizeTypeReference(parameter.Type);
        //            QuoteParameter(parameter);
        //        }

        //        foreach (var parameterTransformation in method.InputParameterTransformation)
        //        {
        //            parameterTransformation.OutputParameter.Name = method.Scope.GetUniqueName(GetParameterName(parameterTransformation.OutputParameter.GetClientName()));
        //            parameterTransformation.OutputParameter.Type = NormalizeTypeReference(parameterTransformation.OutputParameter.Type);
        //            parameterTransformation.OutputParameter = new ParameterModel(parameterTransformation.OutputParameter, method);

        //            QuoteParameter(parameterTransformation.OutputParameter);

        //            foreach (var parameterMapping in parameterTransformation.ParameterMappings)
        //            {
        //                parameterMapping.InputParameter.Name = GetParameterName(parameterMapping.InputParameter.GetClientName());
        //                if (parameterMapping.InputParameterProperty != null)
        //                {
        //                    parameterMapping.InputParameterProperty = GetPropertyName(parameterMapping.InputParameterProperty);
        //                }

        //                if (parameterMapping.OutputParameterProperty != null)
        //                {
        //                    parameterMapping.OutputParameterProperty = GetPropertyName(parameterMapping.OutputParameterProperty);
        //                }
        //            }
        //        }
        //    }
        //}

        ///// <summary>
        ///// Normalizes the client properties names of a client model
        ///// </summary>
        ///// <param name="client">A client model</param>
        //protected override void NormalizeClientProperties(ServiceClient client)
        //{
        //    if (client != null)
        //    {
        //        foreach (var property in client.Properties)
        //        {
        //            property.Name = GetPropertyName(property.GetClientName());
        //            property.Type = NormalizeTypeReference(property.Type);
        //            QuoteParameter(property);
        //        }
        //    }
        //}
        //public override Response NormalizeTypeReference(Response typePair)
        //{
        //    return new Response((IModelTypeJv) NormalizeTypeReference(typePair.Body),
        //                        (IModelTypeJv) NormalizeTypeReference(typePair.Headers));
        //}

        //public override IType NormalizeTypeDeclaration(IType type)
        //{
        //    if (type == null)
        //    {
        //        return null;
        //    }

        //    if (type is IModelTypeJv)
        //    {
        //        return type;
        //    }
        //    if (_visited.ContainsKey(type))
        //    {
        //        return _visited[type];
        //    }

        //    if (type is PrimaryType)
        //    {
        //        _visited[type] = new PrimaryTypeModel(type as PrimaryType);
        //        return _visited[type];
        //    }
        //    if (type is SequenceType)
        //    {
        //        SequenceTypeModel model = new SequenceTypeModel(type as SequenceType);
        //        _visited[type] = model;
        //        return NormalizeSequenceType(model);
        //    }
        //    if (type is DictionaryType)
        //    {
        //        DictionaryTypeModel model = new DictionaryTypeModel(type as DictionaryType);
        //        _visited[type] = model;
        //        return NormalizeDictionaryType(model);
        //    }
        //    if (type is CompositeType)
        //    {
        //        CompositeTypeModel model = NewCompositeTypeModel(type as CompositeType);
        //        _visited[type] = model;
        //        return NormalizeCompositeType(model);
        //    }
        //    if (type is EnumType)
        //    {
        //        EnumTypeModel model = NewEnumTypeModel(type as EnumType);
        //        _visited[type] = model;
        //        return NormalizeEnumType(model);
        //    }


        //    throw new NotSupportedException(string.Format(CultureInfo.InvariantCulture,
        //        "Type {0} is not supported.", type.GetType()));
        //}

        public override IModelType NormalizeTypeReference(IModelType type)
        {
            if (type == null)
            {
                return null;
            }

            var enumType = type as EnumType;
            if (enumType != null && enumType.ModelAsString && enumType.Name.IsNullOrEmpty())
            {
                type = new PrimaryTypeJv(KnownPrimaryType.String);
            }

            return NormalizeTypeDeclaration(type);
        }

        //private IType NormalizeEnumType(EnumType enumType)
        //{
        //    enumType.Name = GetTypeName(enumType.Name);

        //    for (int i = 0; i < enumType.Values.Count; i++)
        //    {
        //        enumType.Values[i].Name = GetEnumMemberName(enumType.Values[i].Name);
        //    }
        //    return enumType;
        //}

        //protected virtual IType NormalizeCompositeType(CompositeType compositeType)
        //{
        //    compositeType.Name = GetTypeName(compositeType.Name);

        //    foreach (var property in compositeType.Properties)
        //    {
        //        property.Name = GetPropertyName(property.GetClientName());
        //        property.Type = NormalizeTypeReference(property.Type);
        //        if (!property.IsRequired)
        //        {
        //            property.Type = WrapPrimitiveType(property.Type);
        //        }
        //    }

        //    if (compositeType.BaseModelType != null) {
        //        compositeType.BaseModelType = (CompositeType) NormalizeTypeReference(compositeType.BaseModelType);
        //    }

        //    return compositeType;
        //}

        //public static PrimaryTypeModel NormalizePrimaryType(PrimaryType primaryType)
        //{
        //    if (primaryType == null)
        //    {
        //        throw new ArgumentNullException("primaryType");
        //    }

        //    return new PrimaryTypeModel(primaryType);
        //}

        //private IType NormalizeSequenceType(SequenceType sequenceType)
        //{
        //    sequenceType.ElementType = WrapPrimitiveType(NormalizeTypeReference(sequenceType.ElementType));
        //    sequenceType.NameFormat = "List<{0}>";
        //    return sequenceType;
        //}

        //private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        //{
        //    dictionaryType.ValueType = WrapPrimitiveType(NormalizeTypeReference(dictionaryType.ValueType));
        //    dictionaryType.NameFormat = "Map<String, {0}>";
        //    return dictionaryType;
        //}

        #endregion

        #region type handling

        //public static IType WrapPrimitiveType(IModelType type)
        //{
        //    var primaryType = type as PrimaryType;
        //    if (primaryType != null)
        //    {
        //        if (type.Name == "boolean")
        //        {
        //            primaryType.Name = "Boolean";
        //        }
        //        else if (type.Name == "double")
        //        {
        //            primaryType.Name = "Double";
        //        }
        //        else if (type.Name == "int")
        //        {
        //            primaryType.Name = "Integer";
        //        }
        //        else if (type.Name == "long")
        //        {
        //            primaryType.Name = "Long";
        //        }

        //        return primaryType;
        //    }
        //    else if (type == null)
        //    {
        //        return new PrimaryType(KnownPrimaryType.None)
        //        {
        //            Name = "Void"
        //        };
        //    }
        //    else
        //    {
        //        return type;
        //    }
        //}

        public static string GetJavaException(string exception, CodeModel cm)
        {
            switch (exception) {
                case "IOException":
                    return "java.io.IOException";
                case "ServiceException":
                    return "com.microsoft.rest.ServiceException";
                case "CloudException":
                    return "com.microsoft.azure.CloudException";
                case "RestException":
                    return "com.microsoft.rest.RestException";
                case "IllegalArgumentException":
                    return null;
                case "InterruptedException":
                    return null;
                default:
                    return (cm.Namespace?.ToLower(CultureInfo.InvariantCulture) ?? "fallbackNamespaceOrWhatTODO")
                        + ".models." + exception;
            }
        }

        #endregion

        public override string EscapeDefaultValue(string defaultValue, IModelType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            var primaryType = type as PrimaryType;
            if (defaultValue != null && primaryType != null)
            {
                if (primaryType.KnownPrimaryType == KnownPrimaryType.String)
                {
                    return QuoteValue(defaultValue);
                }
                else if (primaryType.KnownPrimaryType == KnownPrimaryType.Boolean)
                {
                    return defaultValue.ToLowerInvariant();
                }
                else if (primaryType.KnownPrimaryType == KnownPrimaryType.Long)
                {
                    return defaultValue + "L";
                }
                else
                {
                    if (primaryType.KnownPrimaryType == KnownPrimaryType.Date)
                    {
                        return "LocalDate.parse(\"" + defaultValue + "\")";
                    }
                    else if (primaryType.KnownPrimaryType == KnownPrimaryType.DateTime ||
                        primaryType.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123)
                    {
                        return "DateTime.parse(\"" + defaultValue + "\")";
                    }
                    else if (primaryType.KnownPrimaryType == KnownPrimaryType.TimeSpan)
                    {
                        return "Period.parse(\"" + defaultValue + "\")";
                    }
                    else if (primaryType.KnownPrimaryType == KnownPrimaryType.ByteArray)
                    {
                        return "\"" + defaultValue + "\".getBytes()";
                    }
                }
            }
            return defaultValue;
        }
    }
}