// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using System.Text;
using AutoRest.Core.Model;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Core.Validation;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core
{
    public class CodeNamer
    {
        private static readonly IDictionary<char, string> basicLaticCharacters = new Dictionary<char, string>
        {
            [(char) 32] = "Space",
            [(char) 33] = "ExclamationMark",
            [(char) 34] = "QuotationMark",
            [(char) 35] = "NumberSign",
            [(char) 36] = "DollarSign",
            [(char) 37] = "PercentSign",
            [(char) 38] = "Ampersand",
            [(char) 39] = "Apostrophe",
            [(char) 40] = "LeftParenthesis",
            [(char) 41] = "RightParenthesis",
            [(char) 42] = "Asterisk",
            [(char) 43] = "PlusSign",
            [(char) 44] = "Comma",
            [(char) 45] = "HyphenMinus",
            [(char) 46] = "FullStop",
            [(char) 47] = "Slash",
            [(char) 48] = "Zero",
            [(char) 49] = "One",
            [(char) 50] = "Two",
            [(char) 51] = "Three",
            [(char) 52] = "Four",
            [(char) 53] = "Five",
            [(char) 54] = "Six",
            [(char) 55] = "Seven",
            [(char) 56] = "Eight",
            [(char) 57] = "Nine",
            [(char) 58] = "Colon",
            [(char) 59] = "Semicolon",
            [(char) 60] = "LessThanSign",
            [(char) 61] = "EqualSign",
            [(char) 62] = "GreaterThanSign",
            [(char) 63] = "QuestionMark",
            [(char) 64] = "AtSign",
            [(char) 91] = "LeftSquareBracket",
            [(char) 92] = "Backslash",
            [(char) 93] = "RightSquareBracket",
            [(char) 94] = "CircumflexAccent",
            [(char) 96] = "GraveAccent",
            [(char) 123] = "LeftCurlyBracket",
            [(char) 124] = "VerticalBar",
            [(char) 125] = "RightCurlyBracket",
            [(char) 126] = "Tilde"
        };

        public CodeNamer()
        {
        }

        /// <summary>
        ///     Gets the current code namer instance (using the active context).
        ///     A subclass should set the singleton on creation of their context.
        /// </summary>
        public static CodeNamer Instance
            =>
            Singleton<CodeNamer>.HasInstance
                ? Singleton<CodeNamer>.Instance
                : (Singleton<CodeNamer>.Instance = new CodeNamer());

        /// <summary>
        ///     Gets collection of reserved words.
        /// </summary>
        public HashSet<string> ReservedWords { get; } = new HashSet<string>();

        /// <summary>
        ///     Formats segments of a string split by underscores or hyphens into "Camel" case strings.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string CamelCase(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            
            if (name[0] == '_')
                // Preserve leading underscores.
            {
                return '_' + CamelCase(name.Substring(1));
            }

            return
                name.Split('_', '-', ' ')
                    .Where(s => !string.IsNullOrEmpty(s))
                    .Select((s, i) => FormatCase(s, i == 0)) // Pass true/toLower for just the first element.
                    .DefaultIfEmpty("")
                    .Aggregate(string.Concat);
        }

        /// <summary>
        ///     Formats segments of a string split by underscores or hyphens into "Pascal" case.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string PascalCase(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }

            if (name[0] == '_')
                // Preserve leading underscores and treat them like 
                // uppercase characters by calling 'CamelCase()' on the rest.
            {
                return '_' + CamelCase(name.Substring(1));
            }

            return
                name.Split('_', '-', ' ')
                    .Where(s => !string.IsNullOrEmpty(s))
                    .Select(s => FormatCase(s, false))
                    .DefaultIfEmpty("")
                    .Aggregate(string.Concat);
        }

        /// <summary>
        ///     Wraps value in quotes and escapes quotes inside.
        /// </summary>
        /// <param name="value">String to quote</param>
        /// <param name="quoteChar">Quote character</param>
        /// <param name="escapeChar">Escape character</param>
        /// <exception cref="System.ArgumentNullException">Throw when either quoteChar or escapeChar are null.</exception>
        [SuppressMessage("Microsoft.Design", "CA1026:DefaultParametersShouldNotBeUsed")]
        public virtual string QuoteValue(string value, string quoteChar = "\"", string escapeChar = "\\")
        {
            if (quoteChar == null)
            {
                throw new ArgumentNullException(nameof(quoteChar));
            }
            if (escapeChar == null)
            {
                throw new ArgumentNullException(nameof(escapeChar));
            }
            if (string.IsNullOrWhiteSpace(value))
            {
                value = string.Empty;
            }
            return quoteChar + value.Replace(quoteChar, escapeChar + quoteChar) + quoteChar;
        }

        /// <summary>
        ///     Returns a quoted string for the given language if applicable.
        /// </summary>
        /// <param name="defaultValue">Value to quote.</param>
        /// <param name="type">Data type.</param>
        public virtual string EscapeDefaultValue(string defaultValue, IModelType type)
        {
            return defaultValue;
        }

        /// <summary>
        ///     Formats a string for naming members of an enum using Pascal case by default.
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
        ///     Formats a string for naming fields using a prefix '_' and VariableName Camel case by default.
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
        ///     Formats a string for naming interfaces using a prefix 'I' and Pascal case by default.
        /// </summary>
        /// <param name="name"></param>
        /// <returns>The formatted string.</returns>
        public virtual string GetInterfaceName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            return $"I{PascalCase(RemoveInvalidCharacters(name))}";
        }

        /// <summary>
        ///     Formats a string for naming a method using Pascal case by default.
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
        ///     Formats a string for identifying a namespace using Pascal case by default.
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
        ///     Formats a string for naming method parameters using GetVariableName Camel case by default.
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
        ///     Formats a string for naming properties using Pascal case by default.
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
        ///     Formats a string for naming a Type or Object using Pascal case by default.
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
        ///     Formats a string for naming a Method Group using Pascal case by default.
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
        ///     Formats a string for naming a local variable using Camel case by default.
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
        ///     Returns language specific type reference name.
        /// </summary>
        /// <param name="typePair"></param>
        /// <returns></returns>
        public virtual Response NormalizeTypeReference(Response typePair)
        {
            return new Response(NormalizeTypeReference(typePair.Body),
                NormalizeTypeReference(typePair.Headers));
        }

        /// <summary>
        ///     Returns language specific type reference name.
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public virtual IModelType NormalizeTypeReference(IModelType type)
        {
            return type;
        }

        /// <summary>
        ///     Returns language specific type declaration name.
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public virtual IModelType NormalizeTypeDeclaration(IModelType type)
        {
            return type;
        }


        /// <summary>
        ///     Formats a string as upper or lower case. Two-letter inputs that are all upper case are both lowered.
        ///     Example: ID = > id,  Ex => ex
        /// </summary>
        /// <param name="name"></param>
        /// <param name="toLower"></param>
        /// <returns>The formatted string.</returns>
        private string FormatCase(string name, bool toLower)
        {
            if (!string.IsNullOrEmpty(name))
            {
                if ((name.Length < 2) || ((name.Length == 2) && char.IsUpper(name[0]) && char.IsUpper(name[1])))
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
        ///     Removes invalid characters from the name. Everything but alpha-numeral, underscore,
        ///     and dash.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <returns>Name with invalid characters removed.</returns>
        public virtual string RemoveInvalidCharacters(string name)
        {
            return GetValidName(name, '_', '-');
        }

        /// <summary>
        ///     Removes invalid characters from the namespace. Everything but alpha-numeral, underscore,
        ///     period, and dash.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <returns>Namespace with invalid characters removed.</returns>
        protected virtual string RemoveInvalidCharactersNamespace(string name)
        {
            return GetValidName(name, '_', '-', '.');
        }

        /// <summary>
        ///     Gets valid name for the identifier.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <param name="allowedCharacters">Allowed characters.</param>
        /// <returns>Name with invalid characters removed.</returns>
        public virtual string GetValidName(string name, params char[] allowedCharacters)
        {
            var correctName = RemoveInvalidCharacters(name, allowedCharacters);

            // here we have only letters and digits or an empty string
            if (string.IsNullOrEmpty(correctName) ||
                basicLaticCharacters.ContainsKey(correctName[0]))
            {
                var sb = new StringBuilder();
                foreach (var symbol in name)
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
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, Resources.InvalidIdentifierName,
                    name));
            }

            return correctName;
        }

        /// <summary>
        ///     Removes invalid characters from the name.
        /// </summary>
        /// <param name="name">String to parse.</param>
        /// <param name="allowerCharacters">Allowed characters.</param>
        /// <returns>Name with invalid characters removed.</returns>
        private string RemoveInvalidCharacters(string name, params char[] allowerCharacters)
        {
            return new string(name.Replace("[]", "Sequence")
                .Where(c => char.IsLetterOrDigit(c) || allowerCharacters.Contains(c))
                .ToArray());
        }

        /// <summary>
        ///     If the provided name is a reserved word in a programming language then the method converts the
        ///     name by appending the provided appendValue
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

        public virtual string IsNameLegal(string desiredName, IIdentifier whoIsAsking)
        {
            if (string.IsNullOrWhiteSpace(desiredName))
            {
                // should have never got to this point with an blank name. 
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, Resources.InvalidIdentifierName,
                    desiredName));
            }

            if (ReservedWords.Contains(desiredName))
            {
                return desiredName;
            }

            return null; // null == no conflict
        }

        public virtual IIdentifier IsNameAvailable(string desiredName, HashSet<IIdentifier> reservedNames)
        {
            // null == name is available
            return
                reservedNames.FirstOrDefault(
                    each => each.MyReservedNames.WhereNotNull().Any(name => name.Equals(desiredName)));
        }

        /// <summary>
        /// Returns true when the name comparison is a special case and should not 
        /// be used to determine name conflicts.
        /// 
        /// Override in subclasses so when the model is loaded into the language specific 
        /// context, the behavior can be stricter than here.
        ///  </summary>
        /// <param name="whoIsAsking">the identifier that is checking to see if there is a conflict</param>
        /// <param name="reservedName">the identifier that would normally be reserved.</param>
        /// <returns></returns>
        public virtual bool IsSpecialCase(IIdentifier whoIsAsking, IIdentifier reservedName)
        {
            // special case: properties can actually have the same name as a composite type 
            if (whoIsAsking is Property && reservedName is CompositeType)
            {
                return true;
            }

            // special case: parameters can actually have the same name as a method 
            if (whoIsAsking is Parameter && reservedName is Method)
            {
                return true;
            }

            return false;
        }

        public virtual string GetUnique(string desiredName, IIdentifier whoIsAsking,
            IEnumerable<IIdentifier> reservedNames, IEnumerable<IIdentifier> siblingNames,
            HashSet<string> locallyReservedNames = null)
        {
            // can't disambiguate on an empty name.
            if (string.IsNullOrEmpty(desiredName))
            {
                return desiredName;
            }

#if refactoring_out
            // special case: properties can actually have the same name as a composite type 
            // as long as that type is not the parent class of the property itself.
            if (whoIsAsking is Property)
            {
                reservedNames = reservedNames.Where(each => !(each is CompositeType));

                var parent = (whoIsAsking as IChild)?.Parent as IIdentifier;
                if (parent != null)
                {
                    reservedNames = reservedNames.ConcatSingleItem(parent);
                }
            }
#endif 

            var names = new HashSet<IIdentifier>(reservedNames.Where(each => !IsSpecialCase(whoIsAsking, each)));

            // is this a legal name? -- add a Qualifier Suffix (ie, Method/Model/Property/etc)
            string conflict;
            while ((conflict = IsNameLegal(desiredName, whoIsAsking)) != null)
            {
                desiredName += whoIsAsking.Qualifier;
                // todo: gws: log the name change because it conflicted with a reserved word.
                // Singleton<Log>.Instance?.Add(new Message {Text = $"todo:{conflict}"});

            }

            // does it conflict with a type name locally? (add a Qualifier Suffix)
            
            IIdentifier confl;
            while (null != (confl = IsNameAvailable(desiredName, names)))
            {
                desiredName += whoIsAsking.Qualifier;
                // todo: gws: log the name change because there was something else named that.
                // Singleton<Log>.Instance?.Add(new Message {Text = $"todo:{confl}"});
                // reason = string.Format(CultureInfo.InvariantCulture, Resources.NamespaceConflictReasonMessage,desiredName, ...?
            }


            // special case (corolary): a compositeType  can actually have the same name as a property  
            if (whoIsAsking is CompositeType)
            {
                siblingNames= siblingNames.Where(each => !(each is Property));
            }
            if (whoIsAsking is Property)
            {
                siblingNames = siblingNames.Where(each => !(each is CompositeType));
            }

            // does it have a sibling collision?
            names = new HashSet<IIdentifier>(siblingNames);
            var baseName = desiredName;
            var suffix = 0;
            while (IsNameAvailable(desiredName, names) != null)
            {
                desiredName = baseName + ++suffix;
            }

            // is there a collision with any local name we care about?
            while (true == locallyReservedNames?.Contains(desiredName))
            {
                desiredName = baseName + ++suffix;
            }

            return desiredName;
        }
    }
}