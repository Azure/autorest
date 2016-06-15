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

        [SettingsInfo("Indicates whether to use DateTimeOffset instead of DateTime to model date-time types")]
        public bool UseDateTimeOffset { get; set; }

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

            foreach (var modelType in client.ModelTypes.Concat(client.ErrorTypes).Concat(client.HeaderTypes))
            {
                modelType.Properties.ForEach(p =>
                {
                    if (!p.IsRequired)
                    {
                        MakeTypeNullable(p.Type);
                    }
                });
            }

            foreach (var property in client.Properties)
            {
                if (!property.IsRequired)
                {
                    MakeTypeNullable(property.Type);
                }
            }

            foreach (var method in client.Methods)
            {
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
                        if (!parameter.IsRequired)
                        {
                            MakeTypeNullable(parameter.Type);
                        }
                    }
                }

                if (method.HttpMethod != HttpMethod.Head)
                {
                    foreach (var statusCode in method.Responses.Keys)
                    {
                        MakeTypeNullable(method.Responses[statusCode].Body);
                        MakeTypeNullable(method.Responses[statusCode].Headers);
                    }
                    MakeTypeNullable(method.ReturnType.Body);
                    MakeTypeNullable(method.ReturnType.Headers);
                }

                foreach (var parameterTransformation in method.InputParameterTransformation)
                {
                    if (!parameterTransformation.OutputParameter.IsRequired)
                    {
                        MakeTypeNullable(parameterTransformation.OutputParameter.Type);
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

        private static void MakeTypeNullable(IType type)
        {
            PrimaryType primaryType = type as PrimaryType;
            EnumType enumType = type as EnumType;
            if (primaryType != null)
            {
                if (primaryType.Name != null 
                    && !primaryType.Name.EndsWith("?", StringComparison.OrdinalIgnoreCase)
                    && primaryType.IsValueType())
                {
                    primaryType.Name += "?";
                }
            }
            else if (enumType != null)
            {
                if (enumType.Name != null
                    && !enumType.Name.EndsWith("?", StringComparison.OrdinalIgnoreCase))
                {
                    enumType.Name += "?";
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

            if (primaryType.Type == KnownPrimaryType.Base64Url)
            {
                primaryType.Name = "byte[]";
            }
            else if (primaryType.Type == KnownPrimaryType.Boolean)
            {
                primaryType.Name = "bool";
            }
            else if (primaryType.Type == KnownPrimaryType.ByteArray)
            {
                primaryType.Name = "byte[]";
            }
            else if (primaryType.Type == KnownPrimaryType.Date)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTime)
            {
                primaryType.Name = UseDateTimeOffset ? "DateTimeOffset" : "DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.Double)
            {
                primaryType.Name = "double";
            }
            else if (primaryType.Type == KnownPrimaryType.Decimal)
            {
                primaryType.Name = "decimal";
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
                primaryType.Name = "System.IO.Stream";
            }
            else if (primaryType.Type == KnownPrimaryType.String)
            {
                primaryType.Name = "string";
            }
            else if (primaryType.Type == KnownPrimaryType.TimeSpan)
            {
                primaryType.Name = "TimeSpan";
            }
            else if (primaryType.Type == KnownPrimaryType.Object)
            {
                primaryType.Name = "object";
            }
            else if (primaryType.Type == KnownPrimaryType.Credentials)
            {
                primaryType.Name = "ServiceClientCredentials";
            }
            else if (primaryType.Type == KnownPrimaryType.UnixTime)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.Uuid)
            {
                primaryType.Name = "Guid";
            }

            return primaryType;
        }

        public override IType NormalizeTypeReference(IType type)
        {
            var enumType = type as EnumType;
            if (enumType != null && enumType.ModelAsString)
            {
                return new PrimaryType(KnownPrimaryType.String)
                {
                    Name = "string"
                };
            }
            return NormalizeTypeDeclaration(type);
        }

        private IType NormalizeCompositeType(CompositeType compositeType)
        {
            compositeType.Name = GetTypeName(compositeType.Name);

            foreach (var property in compositeType.Properties)
            {
                property.Name = GetPropertyName(property.GetClientName());
                property.Type = NormalizeTypeReference(property.Type);
            }

            return compositeType;
        }

        private IType NormalizeEnumType(EnumType enumType)
        {
            enumType.Name = GetTypeName(enumType.Name);

            for (int i = 0; i < enumType.Values.Count; i++)
            {
                enumType.Values[i].Name = GetEnumMemberName(enumType.Values[i].Name);
            }
            return enumType;
        }        

        private IType NormalizeSequenceType(SequenceType sequenceType)
        {
            sequenceType.ElementType = NormalizeTypeReference(sequenceType.ElementType);
            if (sequenceType.ElementType.IsValueType())
            {
                sequenceType.NameFormat = "IList<{0}?>";
            }
            else
            {
                sequenceType.NameFormat = "IList<{0}>";
            }
            return sequenceType;
        }

        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            dictionaryType.ValueType = NormalizeTypeReference(dictionaryType.ValueType);
            if (dictionaryType.ValueType.IsValueType())
            {
                dictionaryType.NameFormat = "IDictionary<string, {0}?>";
            }
            else
            {
                dictionaryType.NameFormat = "IDictionary<string, {0}>";
            }
            return dictionaryType;
        }

        public override string EscapeDefaultValue(string defaultValue, IType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            PrimaryType primaryType = type as PrimaryType;
            if (defaultValue != null)
            {
                if (type is CompositeType)
                {
                    return "new " + type.Name + "()";
                }
                else if (primaryType != null)
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
                            primaryType.Type == KnownPrimaryType.DateTimeRfc1123 ||
                            primaryType.Type == KnownPrimaryType.TimeSpan ||
                            primaryType.Type == KnownPrimaryType.ByteArray ||
                            primaryType.Type == KnownPrimaryType.Base64Url ||
                            primaryType.Type == KnownPrimaryType.UnixTime)
                        {

                            return "SafeJsonConvert.DeserializeObject<" + primaryType.Name.TrimEnd('?') +
                                ">(" + CodeNamer.QuoteValue("\"" + defaultValue + "\"") + ", this.Client.SerializationSettings)";
                        }
                    }
                }
            }
            return defaultValue;
        }
    }
}
