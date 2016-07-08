// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;

namespace AutoRest.Core
{
    public abstract class CodeNamer
    {
        private static readonly IDictionary<char, string> basicLaticCharacters;

        protected CodeNamer()
        {
            ReservedWords = new HashSet<string>();
        }

        /// <summary>
        /// Gets collection of reserved words.
        /// </summary>
        public HashSet<string> ReservedWords { get; private set; }

        /// <summary>
        /// Formats segments of a string split by underscores or hyphens into "Camel" case strings.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public static string CamelCase(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            if (name[0] == '_')
                // Preserve leading underscores.
                return '_' + CamelCase(name.Substring(1));

            return
                name.Split('_', '-', ' ')
                    .Where(s => !string.IsNullOrEmpty(s))
                    .Select((s, i) => FormatCase(s, i == 0)) // Pass true/toLower for just the first element.
                    .DefaultIfEmpty("")
                    .Aggregate(string.Concat);
        }

        /// <summary>
        /// Formats segments of a string split by underscores or hyphens into "Pascal" case.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public static string PascalCase(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            if (name[0] == '_')
                // Preserve leading underscores and treat them like 
                // uppercase characters by calling 'CamelCase()' on the rest.
                return '_' + CamelCase(name.Substring(1));

            return
                name.Split('_', '-', ' ')
                    .Where(s => !string.IsNullOrEmpty(s))
                    .Select(s => FormatCase(s, false))
                    .DefaultIfEmpty("")
                    .Aggregate(string.Concat);
        }

        /// <summary>
        /// Wraps value in quotes and escapes quotes inside.
        /// </summary>
        /// <param name="value">String to quote</param>
        /// <param name="quoteChar">Quote character</param>
        /// <param name="escapeChar">Escape character</param>
        /// <exception cref="System.ArgumentNullException">Throw when either quoteChar or escapeChar are null.</exception>
        [SuppressMessage("Microsoft.Design", "CA1026:DefaultParametersShouldNotBeUsed")]
        public static string QuoteValue(string value, string quoteChar = "\"", string escapeChar = "\\")
        {
            if (quoteChar == null)
            {
                throw new ArgumentNullException("quoteChar");
            }
            if (escapeChar == null)
            {
                throw new ArgumentNullException("escapeChar");
            }
            if (value == null)
            {
                value = string.Empty;
            }
            return quoteChar + value.Replace(quoteChar, escapeChar + quoteChar) + quoteChar;
        }

        /// <summary>
        /// Recursively normalizes names in the client model
        /// </summary>
        /// <param name="client"></param>
        public virtual void NormalizeClientModel(ServiceClient client)
        {
            if (client == null)
            {
                throw new ArgumentNullException("client");
            }

            client.Name = GetClientName(client.Name);
            client.Namespace = GetNamespaceName(client.Namespace);

            NormalizeClientProperties(client);

            var normalizedModels = new List<CompositeType>();
            foreach (var modelType in client.ModelTypes)
            {
                normalizedModels.Add(NormalizeTypeDeclaration(modelType) as CompositeType);
                modelType.Properties.ForEach(p => QuoteParameter(p));
            }
            client.ModelTypes.Clear();
            normalizedModels.ForEach((item) => client.ModelTypes.Add(item));

            var normalizedErrors = new List<CompositeType>();
            foreach (var modelType in client.ErrorTypes)
            {
                normalizedErrors.Add(NormalizeTypeDeclaration(modelType) as CompositeType);
            }
            client.ErrorTypes.Clear();
            normalizedErrors.ForEach((item) => client.ErrorTypes.Add(item));

            var normalizedHeaders = new List<CompositeType>();
            foreach (var modelType in client.HeaderTypes)
            {
                normalizedHeaders.Add(NormalizeTypeDeclaration(modelType) as CompositeType);
            }
            client.HeaderTypes.Clear();
            normalizedHeaders.ForEach((item) => client.HeaderTypes.Add(item));

            var normalizedEnums = new List<EnumType>();
            foreach (var enumType in client.EnumTypes)
            {
                var normalizedType = NormalizeTypeDeclaration(enumType) as EnumType;
                if (normalizedType != null)
                {
                    normalizedEnums.Add(NormalizeTypeDeclaration(enumType) as EnumType);
                }
            }
            client.EnumTypes.Clear();
            normalizedEnums.ForEach((item) => client.EnumTypes.Add(item));

            foreach (var method in client.Methods)
            {
                NormalizeMethod(method);
            }
        }

        /// <summary>
        /// Normalizes the client properties names of a client model
        /// </summary>
        /// <param name="client">A client model</param>
        protected virtual void NormalizeClientProperties(ServiceClient client)
        {
            if (client != null)
            {
                foreach (var property in client.Properties)
                {
                    property.Name = GetPropertyName(property.Name);
                    property.Type = NormalizeTypeReference(property.Type);
                    QuoteParameter(property);
                }
            }
        }

        /// <summary>
        /// Normalizes names in the method
        /// </summary>
        /// <param name="method"></param>
        public virtual void NormalizeMethod(Method method)
        {
            if (method == null)
            {
                throw new ArgumentNullException("method");
            }
            method.Name = GetMethodName(method.Name);
            method.Group = GetMethodGroupName(method.Group);
            method.ReturnType = NormalizeTypeReference(method.ReturnType);
            method.DefaultResponse = NormalizeTypeReference(method.DefaultResponse);
            var normalizedResponses = new Dictionary<HttpStatusCode, Response>();
            foreach (var statusCode in method.Responses.Keys)
            {
                normalizedResponses[statusCode] = NormalizeTypeReference(method.Responses[statusCode]);
            }

            method.Responses.Clear();
            foreach (var statusCode in normalizedResponses.Keys)
            {
                method.Responses[statusCode] = normalizedResponses[statusCode];
            }

            NormalizeParameters(method);

        }

        /// <summary>
        /// Normalizes the parameter names of a method
        /// </summary>
        /// <param name="method">A method model</param>
        protected virtual void NormalizeParameters(Method method)
        {
            if (method != null)
            {
                foreach (var parameter in method.Parameters)
                {
                    parameter.Name = method.Scope.GetUniqueName(GetParameterName(parameter.Name));
                    parameter.Type = NormalizeTypeReference(parameter.Type);
                    QuoteParameter(parameter);
                }

                foreach (var parameterTransformation in method.InputParameterTransformation)
                {
                    parameterTransformation.OutputParameter.Name = method.Scope.GetUniqueName(GetParameterName(parameterTransformation.OutputParameter.Name));
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
        /// Quotes default value of the parameter.
        /// </summary>
        /// <param name="parameter"></param>
        protected void QuoteParameter(IParameter parameter)
        {
            if (parameter != null)
            {
                parameter.DefaultValue = EscapeDefaultValue(parameter.DefaultValue, parameter.Type);
            }            
        }

        /// <summary>
        /// Returns a quoted string for the given language if applicable.
        /// </summary>
        /// <param name="defaultValue">Value to quote.</param>
        /// <param name="type">Data type.</param>
        public abstract string EscapeDefaultValue(string defaultValue, IType type);

        /// <summary>
        /// Formats a string for naming members of an enum using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetEnumMemberName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return PascalCase(RemoveInvalidCharacters(name));
        }

        /// <summary>
        /// Formats a string for naming fields using a prefix '_' and VariableName Camel case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetFieldName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return '_' + GetVariableName(name);
        }

        /// <summary>
        /// Formats a string for naming interfaces using a prefix 'I' and Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetInterfaceName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return "I" + PascalCase(RemoveInvalidCharacters(name));
        }

        /// <summary>
        /// Formats a string for naming a method using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetMethodName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return PascalCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Operation")));
        }

        /// <summary>
        /// Formats a string for identifying a namespace using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetNamespaceName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return PascalCase(RemoveInvalidCharactersNamespace(name));
        }

        /// <summary>
        /// Formats a string for naming method parameters using GetVariableName Camel case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetParameterName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return GetVariableName(GetEscapedReservedName(name, "Parameter"));
        }

        /// <summary>
        /// Formats a string for naming properties using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetPropertyName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return PascalCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Property")));
        }

        /// <summary>
        /// Formats a string for naming a Type or Object using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetTypeName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return PascalCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Model")));
        }

        /// <summary>
        /// Formats a string for naming a Method Group using Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetMethodGroupName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return PascalCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Model")));
        }

        public virtual string GetClientName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return PascalCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Model")));
        }

        /// <summary>
        /// Formats a string for naming a local variable using Camel case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetVariableName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return CamelCase(RemoveInvalidCharacters(GetEscapedReservedName(name, "Variable")));
        }

        /// <summary>
        /// Returns language specific type reference name.
        /// </summary>
        /// <param name="typePair"></param>
        /// <returns></returns>
        public virtual Response NormalizeTypeReference(Response typePair)
        {
            return new Response(NormalizeTypeReference(typePair.Body),
                                NormalizeTypeReference(typePair.Headers));
        }

        /// <summary>
        /// Returns language specific type reference name.
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public abstract IType NormalizeTypeReference(IType type);

        /// <summary>
        /// Returns language specific type declaration name.
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public abstract IType NormalizeTypeDeclaration(IType type);


        /// <summary>
        /// Formats a string as upper or lower case. Two-letter inputs that are all upper case are both lowered.
        /// Example: ID = > id,  Ex => ex
        /// </summary>
        /// <param name="name"></param>
        /// <param name="toLower"></param>
        /// <returns>The formatted string.</returns>
        private static string FormatCase(string name, bool toLower)
        {
            if (!string.IsNullOrEmpty(name))
            {
                if (name.Length < 2 || (name.Length == 2 && char.IsUpper(name[0]) && char.IsUpper(name[1])))
                {
                    name = toLower ? name.ToLowerInvariant() : name.ToUpperInvariant();
                }
                else
                {
                    name =
                        (toLower
                            ? char.ToLowerInvariant(name[0])
                            : char.ToUpperInvariant(name[0])) + name.Substring(1, name.Length - 1);
                }
            }
            return name;
        }

        /// <summary>
        /// Removes invalid characters from the name. Everything but alpha-numeral, underscore,
        /// and dash.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <returns>Name with invalid characters removed.</returns>
        public static string RemoveInvalidCharacters(string name)
        {
            return GetValidName(name, '_', '-');
        }

        /// <summary>
        /// Removes invalid characters from the namespace. Everything but alpha-numeral, underscore,
        /// period, and dash.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <returns>Namespace with invalid characters removed.</returns>
        protected virtual string RemoveInvalidCharactersNamespace(string name)
        {
            return GetValidName(name, '_', '-', '.');
        }

        /// <summary>
        /// Gets valid name for the identifier.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <param name="allowedCharacters">Allowed characters.</param>
        /// <returns>Name with invalid characters removed.</returns>
        protected static string GetValidName(string name, params char[] allowedCharacters)
        {
            var correctName = RemoveInvalidCharacters(name, allowedCharacters);

            // here we have only letters and digits or an empty string
            if (string.IsNullOrEmpty(correctName) ||
                basicLaticCharacters.ContainsKey(correctName[0]))
            {
                var sb = new StringBuilder();
                foreach (char symbol in name)
                {
                    if (basicLaticCharacters.ContainsKey(symbol))
                    {
                        sb.Append(basicLaticCharacters[symbol]);
                    }
                    else
                    {
                        sb.Append(symbol);
                    }
                }
                correctName = RemoveInvalidCharacters(sb.ToString(), allowedCharacters);
            }

            // if it is still empty string, throw
            if (correctName.IsNullOrEmpty())
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, Resources.InvalidIdentifierName, name));
            }

            return correctName;
        }

        /// <summary>
        /// Removes invalid characters from the name.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <param name="allowerCharacters">Allowed characters.</param>
        /// <returns>Name with invalid characters removed.</returns>
        private static string RemoveInvalidCharacters(string name, params char[] allowerCharacters)
        {
            return new string(name.Replace("[]", "Sequence")
                   .Where(c => char.IsLetterOrDigit(c) || allowerCharacters.Contains(c))
                   .ToArray());
        }

        /// <summary>
        /// If the provided name is a reserved word in a programming language then the method converts the
        /// name by appending the provided appendValue
        /// </summary>
        /// <param name="name">Name.</param>
        /// <param name="appendValue">String to append.</param>
        /// <returns>The transformed reserved name</returns>
        protected virtual string GetEscapedReservedName(string name, string appendValue)
        {
            if (name == null)
            {
                throw new ArgumentNullException("name");
            }

            if (appendValue == null)
            {
                throw new ArgumentNullException("appendValue");
            }

            if (ReservedWords.Contains(name, StringComparer.OrdinalIgnoreCase))
            {
                name += appendValue;
            }

            return name;
        }

        /// <summary>
        /// Resolves name collisions in the client model by iterating over namespaces (if provided,
        /// model names, client name, and client method groups.
        /// </summary>
        /// <param name="serviceClient">Service client to process.</param>
        /// <param name="clientNamespace">Client namespace or null.</param>
        /// <param name="modelNamespace">Client model namespace or null.</param>
        public virtual void ResolveNameCollisions(ServiceClient serviceClient, string clientNamespace,
            string modelNamespace)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            // take all namespaces of Models
            var exclusionListQuery = SplitNamespaceAndIgnoreLast(modelNamespace)
                .Union(SplitNamespaceAndIgnoreLast(clientNamespace));

            var exclusionDictionary = new Dictionary<string, string>(exclusionListQuery
                .Where(s => !string.IsNullOrWhiteSpace(s))
                .ToDictionary(s => s, v => "namespace"), StringComparer.OrdinalIgnoreCase);

            var models = new List<CompositeType>(serviceClient.ModelTypes);
            serviceClient.ModelTypes.Clear();
            foreach (var model in models)
            {
                model.Name = ResolveNameConflict(
                    exclusionDictionary,
                    model.Name,
                    "Schema definition",
                    "Model");

                serviceClient.ModelTypes.Add(model);
            }

            models = new List<CompositeType>(serviceClient.HeaderTypes);
            serviceClient.HeaderTypes.Clear();
            foreach (var model in models)
            {
                model.Name = ResolveNameConflict(
                    exclusionDictionary,
                    model.Name,
                    "Schema definition",
                    "Model");

                serviceClient.HeaderTypes.Add(model);
            }

            foreach (var model in serviceClient.ModelTypes
                                                  .Concat(serviceClient.HeaderTypes)
                                                  .Concat(serviceClient.ErrorTypes))
            {
                foreach (var property in model.Properties)
                {
                    if (property.Name.Equals(model.Name, StringComparison.OrdinalIgnoreCase))
                    {
                        property.Name += "Property";
                    }
                }
            }

            var enumTypes = new List<EnumType>(serviceClient.EnumTypes);
            serviceClient.EnumTypes.Clear();

            foreach (var enumType in enumTypes)
            {
                enumType.Name = ResolveNameConflict(
                    exclusionDictionary,
                    enumType.Name,
                    "Enum name",
                    "Enum");

                serviceClient.EnumTypes.Add(enumType);
            }

            serviceClient.Name = ResolveNameConflict(
                exclusionDictionary,
                serviceClient.Name,
                "Client",
                "Client");

            ResolveMethodGroupNameCollision(serviceClient, exclusionDictionary);
        }

        /// <summary>
        /// Resolves name collisions in the client model for method groups (operations).
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="exclusionDictionary"></param>
        protected virtual void ResolveMethodGroupNameCollision(ServiceClient serviceClient,
            Dictionary<string, string> exclusionDictionary)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            if (exclusionDictionary == null)
            {
                throw new ArgumentNullException("exclusionDictionary");
            }

            var methodGroups = serviceClient.MethodGroups.ToList();

            foreach (var methodGroup in methodGroups)
            {
                var resolvedName = ResolveNameConflict(
                    exclusionDictionary,
                    methodGroup,
                    "Client operation",
                    "Operations");
                foreach (var method in serviceClient.Methods)
                {
                    if (method.Group == methodGroup)
                    {
                        method.Group = resolvedName;
                    }
                }
            }
        }

        protected static string ResolveNameConflict(
            Dictionary<string, string> exclusionDictionary,
            string typeName,
            string type,
            string suffix)
        {
            string resolvedName = typeName;
            var sb = new StringBuilder();

            sb.AppendLine();

            while (exclusionDictionary.ContainsKey(resolvedName))
            {
                sb.AppendLine(string.Format(CultureInfo.InvariantCulture,
                    Resources.NamespaceConflictReasonMessage,
                    resolvedName,
                    exclusionDictionary[resolvedName]));

                resolvedName += suffix;
            }

            if (!string.Equals(resolvedName, typeName, StringComparison.OrdinalIgnoreCase))
            {
                sb.AppendLine(Resources.NamingConflictsSuggestion);

                Logger.LogWarning(
                    string.Format(
                        CultureInfo.InvariantCulture,
                        Resources.EntityConflictTitleMessage,
                        type,
                        typeName,
                        resolvedName,
                        sb));
            }

            exclusionDictionary.Add(resolvedName, type);
            return resolvedName;
        }

        private static IEnumerable<string> SplitNamespaceAndIgnoreLast(string nameSpace)
        {
            if (string.IsNullOrEmpty(nameSpace))
            {
                return Enumerable.Empty<string>();
            }
            var namespaceWords = nameSpace.Split(new[] {'.'}, StringSplitOptions.RemoveEmptyEntries);
            if (namespaceWords.Length < 1)
            {
                return Enumerable.Empty<string>();
            }
            // else we do not need the last part of the namespace
            return namespaceWords.Take(namespaceWords.Length - 1);
        }

        [SuppressMessage("Microsoft.Performance", "CA1810:InitializeReferenceTypeStaticFieldsInline")]
        static CodeNamer()
        {
            basicLaticCharacters = new Dictionary<char, string>();
            basicLaticCharacters[(char)32] = "Space";
            basicLaticCharacters[(char)33] = "ExclamationMark";
            basicLaticCharacters[(char)34] = "QuotationMark";
            basicLaticCharacters[(char)35] = "NumberSign";
            basicLaticCharacters[(char)36] = "DollarSign";
            basicLaticCharacters[(char)37] = "PercentSign";
            basicLaticCharacters[(char)38] = "Ampersand";
            basicLaticCharacters[(char)39] = "Apostrophe";
            basicLaticCharacters[(char)40] = "LeftParenthesis";
            basicLaticCharacters[(char)41] = "RightParenthesis";
            basicLaticCharacters[(char)42] = "Asterisk";
            basicLaticCharacters[(char)43] = "PlusSign";
            basicLaticCharacters[(char)44] = "Comma";
            basicLaticCharacters[(char)45] = "HyphenMinus";
            basicLaticCharacters[(char)46] = "FullStop";
            basicLaticCharacters[(char)47] = "Slash";
            basicLaticCharacters[(char)48] = "Zero";
            basicLaticCharacters[(char)49] = "One";
            basicLaticCharacters[(char)50] = "Two";
            basicLaticCharacters[(char)51] = "Three";
            basicLaticCharacters[(char)52] = "Four";
            basicLaticCharacters[(char)53] = "Five";
            basicLaticCharacters[(char)54] = "Six";
            basicLaticCharacters[(char)55] = "Seven";
            basicLaticCharacters[(char)56] = "Eight";
            basicLaticCharacters[(char)57] = "Nine";
            basicLaticCharacters[(char)58] = "Colon";
            basicLaticCharacters[(char)59] = "Semicolon";
            basicLaticCharacters[(char)60] = "LessThanSign";
            basicLaticCharacters[(char)61] = "EqualSign";
            basicLaticCharacters[(char)62] = "GreaterThanSign";
            basicLaticCharacters[(char)63] = "QuestionMark";
            basicLaticCharacters[(char)64] = "AtSign";
            basicLaticCharacters[(char)91] = "LeftSquareBracket";
            basicLaticCharacters[(char)92] = "Backslash";
            basicLaticCharacters[(char)93] = "RightSquareBracket";
            basicLaticCharacters[(char)94] = "CircumflexAccent";
            basicLaticCharacters[(char)96] = "GraveAccent";
            basicLaticCharacters[(char)123] = "LeftCurlyBracket";
            basicLaticCharacters[(char)124] = "VerticalBar";
            basicLaticCharacters[(char)125] = "RightCurlyBracket";
            basicLaticCharacters[(char)126] = "Tilde";
        }
    }
}
