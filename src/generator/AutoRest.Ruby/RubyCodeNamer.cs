// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.Ruby
{
    /// <summary>
    /// A class which keeps all naming related functionality.
    /// </summary>
    public class RubyCodeNamer : CodeNamer
    {
        /// <summary>
        /// The set of already normalized types.
        /// </summary>
        private readonly HashSet<IType> normalizedTypes;

        /// <summary>
        /// Initializes a new instance of RubyCodeNamer.
        /// </summary>
        public RubyCodeNamer()
        {
            new HashSet<string>
            {
                "begin",    "do",       "next",     "then",     "end",
                "else",     "nil",      "true",     "alias",    "elsif",
                "not",      "undef",    "and",      "end",      "or",
                "unless",   "begin",    "ensure",   "redo",     "until",
                "break",    "false",    "rescue",   "when",     "case",
                "for",      "retry",    "while",    "class",    "if",
                "return",   "while",    "def",      "in",       "self",
                "__file__", "defined?", "module",   "super",    "__line__",
                "yield"
            }.ForEach(s => ReservedWords.Add(s));

            normalizedTypes = new HashSet<IType>();
        }

        /// <summary>
        /// Formats segments of a string into "underscore" case.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public static string UnderscoreCase(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                return name;
            }

            return Regex.Replace(name, @"(\p{Ll})(\p{Lu})", "$1_$2").ToLower();
        }

        /// <summary>
        /// Corrects characters for Ruby compatibility.
        /// </summary>
        /// <param name="name">String to correct.</param>
        /// <returns>Corrected string.</returns>
        public string RubyRemoveInvalidCharacters(string name)
        {
            if (string.IsNullOrEmpty(name))
            {
                return name;
            }

            return RemoveInvalidCharacters(name).Replace('-', '_');
        }

        /// <summary>
        /// Returns name for the method which doesn't contain forbidden characters for current language.
        /// </summary>
        /// <param name="name">The intended name of method.</param>
        /// <returns>The corrected name of method.</returns>
        public override string GetMethodName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Operation")));
        }

        /// <summary>
        /// Returns name for the field which doesn't contain forbidden characters for current language.
        /// </summary>
        /// <param name="name">The intended name of field.</param>
        /// <returns>The corrected name of field.</returns>
        public override string GetFieldName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return GetVariableName(name);
        }

        /// <summary>
        /// Returns name for the property which doesn't contain forbidden characters for current language.
        /// </summary>
        /// <param name="name">The intended name of property.</param>
        /// <returns>The corrected name of property.</returns>
        public override string GetPropertyName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Property")));
        }

        /// <summary>
        /// Returns name for the variable which doesn't contain forbidden characters for current language.
        /// </summary>
        /// <param name="name">The intended name of variable.</param>
        /// <returns>The corrected name of variable.</returns>
        public override string GetVariableName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            return UnderscoreCase(RubyRemoveInvalidCharacters(GetEscapedReservedName(name, "Variable")));
        }

        /// <summary>
        /// Normalizes client model - corrects names/types to adapt them to current language.
        /// </summary>
        /// <param name="client">The service client.</param>
        public override void NormalizeClientModel(ServiceClient client)
        {
            if (client == null)
            {
                throw new ArgumentNullException("client");
            }

            base.NormalizeClientModel(client);
            foreach (var method in client.Methods)
            {
                foreach (var parameter in method.Parameters)
                {
                    if (parameter.ClientProperty != null)
                    {
                        if (method.Group == null)
                        {
                            parameter.Name = parameter.ClientProperty.Name;
                        }
                        else
                        {
                            parameter.Name = string.Format(CultureInfo.InvariantCulture, "{0}.{1}", "@client", parameter.ClientProperty.Name);
                        }
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

        /// <summary>
        /// Normalizes given type.
        /// </summary>
        /// <param name="type">Type to normalize.</param>
        /// <returns>Normalized type.</returns>
        public override IType NormalizeTypeReference(IType type)
        {
            if (type == null)
            {
                return null;
            }
            // Using Any instead of Contains since object hash is bound to a property which is modified during normalization
            if (normalizedTypes.Any(item => type.Equals(item)))
            {
                return normalizedTypes.First(item => type.Equals(item));
            }

            normalizedTypes.Add(type);
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

            throw new NotSupportedException(string.Format("Type {0} is not supported.", type.GetType()));
        }

        /// <summary>
        /// Normalizes composite type.
        /// </summary>
        /// <param name="compositeType">Type to normalize.</param>
        /// <returns>Normalized type.</returns>
        private IType NormalizeCompositeType(CompositeType compositeType)
        {
            compositeType.Name = GetTypeName(compositeType.Name);

            foreach (var property in compositeType.Properties)
            {
                property.Name = GetPropertyName(property.GetClientName());
                if (property.SerializedName != null && !property.WasFlattened())
                {
                    property.SerializedName = property.SerializedName.Replace(".", "\\\\.");
                }
                property.Type = NormalizeTypeReference(property.Type);
            }

            return compositeType;
        }

        /// <summary>
        /// Normalizes enum type.
        /// </summary>
        /// <param name="enumType">The enum type.</param>
        /// <returns>Normalized enum type.</returns>
        private IType NormalizeEnumType(EnumType enumType)
        {
            if (!String.IsNullOrWhiteSpace(enumType.Name))
            {
                enumType.Name = PascalCase(RemoveInvalidCharacters(enumType.Name));
            }
            for (int i = 0; i < enumType.Values.Count; i++)
            {
                if (enumType.Values[i].Name != null)
                {
                    enumType.Values[i].Name = GetEnumMemberName(RubyRemoveInvalidCharacters(enumType.Values[i].Name));
                }
            }

            return enumType;
        }

        /// <summary>
        /// Normalizes primary type.
        /// </summary>
        /// <param name="primaryType">Primary type to normalize.</param>
        /// <returns>Normalized primary type.</returns>
        private IType NormalizePrimaryType(PrimaryType primaryType)
        {
            if (primaryType == null)
            {
                throw new ArgumentNullException("primaryType");
            }

            if (primaryType.Type == KnownPrimaryType.Base64Url)
            {
                primaryType.Name = "String";
            }
            else if (primaryType.Type == KnownPrimaryType.Boolean)
            {
                primaryType.Name = "Boolean";
            }
            else if (primaryType.Type == KnownPrimaryType.ByteArray)
            {
                primaryType.Name = "Array";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTime)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.DateTimeRfc1123)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.Double)
            {
                primaryType.Name = "Float";
            }
            else if (primaryType.Type == KnownPrimaryType.Decimal)
            {
                primaryType.Name = "Float";
            }
            else if (primaryType.Type == KnownPrimaryType.Int)
            {
                primaryType.Name = "Number";
            }
            else if (primaryType.Type == KnownPrimaryType.Long)
            {
                primaryType.Name = "Bignum";
            }
            else if (primaryType.Type == KnownPrimaryType.Stream)
            {
                // TODO: Ruby doesn't supports streams.
                primaryType.Name = "System.IO.Stream";
            }
            else if (primaryType.Type == KnownPrimaryType.String)
            {
                primaryType.Name = "String";
            }
            else if (primaryType.Type == KnownPrimaryType.TimeSpan)
            {
                primaryType.Name = "Duration";
            }
            else if (primaryType.Type == KnownPrimaryType.UnixTime)
            {
                primaryType.Name = "DateTime";
            }
            else if (primaryType.Type == KnownPrimaryType.Object)
            {
                primaryType.Name = "Object";
            }

            return primaryType;
        }

        /// <summary>
        /// Normalizes sequence type.
        /// </summary>
        /// <param name="sequenceType">The sequence type.</param>
        /// <returns>Normalized sequence type.</returns>
        private IType NormalizeSequenceType(SequenceType sequenceType)
        {
            sequenceType.ElementType = NormalizeTypeReference(sequenceType.ElementType);
            sequenceType.NameFormat = "Array";
            return sequenceType;
        }

        /// <summary>
        /// Normalizes dictionary type.
        /// </summary>
        /// <param name="dictionaryType">The dictionary type.</param>
        /// <returns>Normalized dictionary type.</returns>
        private IType NormalizeDictionaryType(DictionaryType dictionaryType)
        {
            dictionaryType.ValueType = NormalizeTypeReference(dictionaryType.ValueType);
            dictionaryType.NameFormat = "Hash";
            return dictionaryType;
        }

        public override string EscapeDefaultValue(string defaultValue, IType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            PrimaryType primaryType = type as PrimaryType;
            if (defaultValue != null && primaryType != null)
            {
                if (primaryType.Type == KnownPrimaryType.String)
                {
                    return CodeNamer.QuoteValue(defaultValue, quoteChar: "'");
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
                        primaryType.Type == KnownPrimaryType.TimeSpan)
                    {
                        return "Date.parse('" + defaultValue + "')";
                    }

                    if (primaryType.Type == KnownPrimaryType.ByteArray)
                    {
                        return "'" + defaultValue + "'.bytes.pack('C*')";
                    }
                }
            }

            EnumType enumType = type as EnumType;
            if (defaultValue != null && enumType != null)
            {
                return CodeNamer.QuoteValue(defaultValue, quoteChar: "'");
            }
            return defaultValue;
        }
    }
}
