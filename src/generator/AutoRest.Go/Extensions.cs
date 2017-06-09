// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Extensions;
using AutoRest.Go.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace AutoRest.Go
{
    public static class Extensions
    {
        public const string NullConstraint = "Null";

        public const string ReadOnlyConstraint = "ReadOnly";

        private static readonly Regex IsApiVersionPattern = new Regex(@"^api[^a-zA-Z0-9_]?version", RegexOptions.IgnoreCase);

        private static readonly Regex UnwrapAnchorTagsPattern = new Regex("([^<>]*)<a\\s*.*\\shref\\s*=\\s*[\'\"]([^\'\"]*)[\'\"][^>]*>(.*)</a>");

        private static readonly Regex WordSplitPattern = new Regex(@"(\p{Lu}\p{Ll}+)");

        private static Dictionary<string, string> plural = new Dictionary<string, string>()
        {
            { "eventhub", "eventhubs" },
            { "containerservice", "containerservices" }
        };

        /////////////////////////////////////////////////////////////////////////////////////////
        //
        // General Extensions
        //
        /////////////////////////////////////////////////////////////////////////////////////////

        /// <summary>
        /// This method changes string to sentence where is make the first word 
        /// of sentence to lowercase (unless it is an acronym). The sentence is coming directly from swagger.
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string ToSentence(this string value)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                return string.Empty;
            }
            else
            {
                value = value.Trim();
                if (value.StartsWithAcronym())
                {
                    return value;
                }                
                return value.First().ToString().ToLowerInvariant() + (value.Length > 1 ? value.Substring(1) : "");
            }
        }

        /// <summary>
        /// Determines if the first word in a string is an acronym
        /// (acronym defined as all caps and more than 1 char)
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static bool StartsWithAcronym(this string value)
        {
            string firstWord = value.Trim().Split(' ', '-', '_').First();
            return firstWord.Length > 1 && firstWord.All(c => char.IsUpper(c));
        }

        /// <summary>
        /// Makes first word of the sentence as upper case.
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string Capitalize(this string value)
        {
            return string.IsNullOrWhiteSpace(value)
                    ? string.Empty
                    : value.First()
                           .ToString()
                           .ToUpperInvariant() + (value.Length > 1 ? value.Substring(1) : "");
        }

        /// <summary>
        /// String manipulation function converts all words in a sentence to lowercase.
        /// Refactor -> Namer
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string ToPhrase(this string value)
        {
            List<string> words = new List<string>(value.ToWords());
            for (int i = 0; i < words.Count; i++)
            {
                words[i] = words[i].ToLowerInvariant();
            }
            return string.Join(" ", words.ToArray());
        }

        /// <summary>
        /// Split sentence into words.
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string[] ToWords(this string value)
        {
            return WordSplitPattern.Split(value).Where(s => !string.IsNullOrEmpty(s)).ToArray();
        }

        /// <summary>
        /// This method checks if MethodGroupName is plural of package name. 
        /// It returns false for packages not listed in dictionary 'plural'.
        /// Example, group EventHubs in package EventHub.
        /// Refactor -> Namer, but also could be used by the CodeModelTransformer
        /// </summary>
        /// <param name="value"></param>
        /// <param name="packageName"></param>
        /// <returns></returns>
        public static bool IsNamePlural(this string value, string packageName)
        {
            return plural.ContainsKey(packageName) && plural[packageName] == value.ToLower();
        }

        /// <summary>
        /// Gets substring from value string.
        /// </summary>
        /// <param name="value"></param>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string TrimStartsWith(this string value, string s)
        {
            if (!string.IsNullOrEmpty(s) && s.Length < value.Length && value.StartsWith(s, StringComparison.OrdinalIgnoreCase))
            {
                value = value.Substring(s.Length);
            }
            return value;
        }

        /// <summary>
        /// Removes the package name from the beginning of a type or method name.
        /// Refactor -> Namer, but could be used by the CodeModelTransformer too
        /// </summary>
        /// <param name="value">The name of the type or method from which to remove the package name.</param>
        /// <param name="packageName">The name of the package to be removed.</param>
        /// <returns>A string containing the modified name.</returns>
        public static string TrimPackageName(this string value, string packageName)
        {
            // check if the package name straddles a casing boundary, if it
            // does then don't trim the name.  e.g. if value == "SubscriptionState"
            // and packageName == "subscriptions" it would be incorrect to remove
            // the package name from the value.

            bool straddle = value.Length > packageName.Length && !char.IsUpper(value[packageName.Length]);

            var originalLen = value.Length;

            if (!straddle)
                value = value.TrimStartsWith(packageName);

            // if nothing was trimmed and the package name is plural then make the
            // package name singular and try removing that if it's not too short
            if (value.Length == originalLen && packageName.EndsWith("s") && (value.Length - packageName.Length + 1) > 1)
            {
                value = value.TrimPackageName(packageName.Substring(0, packageName.Length - 1));
            }

            return value;
        }

        /// <summary>
        /// Converts List to formatted string of arguments.
        /// Refactor -> Generator
        /// </summary>
        /// <param name="arguments"></param>
        /// <returns></returns>
        public static string EmitAsArguments(this IList<string> arguments)
        {
            var sb = new StringBuilder();

            if (arguments.Count() > 0)
            {
                sb.Append(arguments[0]);

                for (var i = 1; i < arguments.Count(); i++)
                {
                    sb.AppendLine(",");
                    sb.Append(arguments[i]);
                }
            }
            return sb.ToString();
        }


        // This function removes html anchor tags and reformats the comment text.
        // For example, Swagger documentation text --> "This is a documentation text. For information see <a href=LINK">CONTENT.</a>"
        // reformats to  --> "This is a documentation text. For information see CONTENT (LINK)."
        // Refactor -> Namer
        // Still, nobody uses this...
        public static string UnwrapAnchorTags(this string comments)
        {

            Match match = UnwrapAnchorTagsPattern.Match(comments);

            if (match.Success)
            {
                string content = match.Groups[3].Value;
                string link = match.Groups[2].Value;

                return (".?!;:".Contains(content[content.Length - 1])
                        ? match.Groups[1].Value + content.Substring(0, content.Length - 1) + " (" + link + ")" + content[content.Length - 1]
                        : match.Groups[1].Value + content + " (" + link + ")");
            }

            return comments;
        }

        /// <summary>
        /// Return the separator associated with a given collectionFormat
        /// It looks like other generators use this for split / join operations ?
        /// Refactor -> I think CodeMoedelTransformer
        /// </summary>
        /// <param name="format">The collection format</param>
        /// <returns>The separator</returns>
        public static string GetSeparator(this CollectionFormat format)
        {
            switch (format)
            {
                case CollectionFormat.Csv:
                    return ",";
                case CollectionFormat.Pipes:
                    return "|";
                case CollectionFormat.Ssv:
                    return " ";
                case CollectionFormat.Tsv:
                    return "\t";
                default:
                    throw new NotSupportedException(string.Format("Collection format {0} is not supported.", format));
            }
        }

        public static bool IsApiVersion(this string name)
        {
            return IsApiVersionPattern.IsMatch(name);
        }

        /////////////////////////////////////////////////////////////////////////////////////////
        //
        // Type Extensions
        //
        /////////////////////////////////////////////////////////////////////////////////////////

        public static bool IsStreamType(this IModelType body)
        {
            var r = body as CompositeTypeGo;
            return r != null && (r.BaseType.PrimaryType(KnownPrimaryType.Stream));
        }

        public static bool PrimaryType(this IModelType type, KnownPrimaryType typeToMatch)
        {
            if (type == null)
            {
                return false;
            }

            PrimaryType primaryType = type as PrimaryType;
            return primaryType != null && primaryType.KnownPrimaryType == typeToMatch;
        }

        public static bool CanBeEmpty(this IModelType type)
        {
            var dictionaryType = type as DictionaryType;
            var primaryType = type as PrimaryType;
            var sequenceType = type as SequenceType;
            var enumType = type as EnumType;

            return dictionaryType != null
                || (primaryType != null
                 && (primaryType.KnownPrimaryType == KnownPrimaryType.ByteArray
                        || primaryType.KnownPrimaryType == KnownPrimaryType.Stream
                        || primaryType.KnownPrimaryType == KnownPrimaryType.String))
                || sequenceType != null
                || enumType != null;
        }

        /// <summary>
        /// Returns true if the specified type can be implicitly null.
        /// E.g. things like maps, arrays, interfaces etc can all be null.
        /// </summary>
        /// <param name="type">The type to inspect.</param>
        /// <returns>True if the specified type can be null.</returns>
        public static bool CanBeNull(this IModelType type)
        {
            var dictionaryType = type as DictionaryType;
            var primaryType = type as PrimaryType;
            var sequenceType = type as SequenceType;

            return dictionaryType != null
                || (primaryType != null
                   && (primaryType.KnownPrimaryType == KnownPrimaryType.ByteArray
                      || primaryType.KnownPrimaryType == KnownPrimaryType.Stream))
                || sequenceType != null;
        }

        public static string GetEmptyCheck(this IModelType type, string valueReference, bool asEmpty = true)
        {
            if (type is PrimaryTypeGo)
            {
                return (type as PrimaryTypeGo).GetEmptyCheck(valueReference, asEmpty);
            }
            else if (type is SequenceTypeGo)
            {
                return (type as SequenceTypeGo).GetEmptyCheck(valueReference, asEmpty);
            }
            else if (type is DictionaryTypeGo)
            {
                return (type as DictionaryTypeGo).GetEmptyCheck(valueReference, asEmpty);
            }
            else if (type is EnumTypeGo)
            {
                return (type as EnumTypeGo).GetEmptyCheck(valueReference, asEmpty);
            }
            else
            {
                return string.Format(asEmpty
                                        ? "{0} == nil"
                                        : "{0} != nil", valueReference);
            }
        }

        /// <summary>
        /// Add imports for a type.
        /// </summary>
        /// <param name="type"></param>
        /// <param name="imports"></param>
        public static void AddImports(this IModelType type, HashSet<string> imports)
        {
            if (type is DictionaryTypeGo typeDict)
            {
                typeDict.AddImports(imports);
            }
            else if (type is PrimaryTypeGo typePrimary)
            {
                typePrimary.AddImports(imports);
            }
            else if (type is SequenceTypeGo typeSeq)
            {
                typeSeq.AddImports(imports);
            }
        }

        public static bool ShouldBeSyntheticType(this IModelType type)
        {
            return (type is PrimaryType || type is SequenceType || type is DictionaryType || type is EnumType);
        }

        /////////////////////////////////////////////////////////////////////////////////////////
        // Validate code
        //
        // This code generates a validation object which is defined in 
        // go-autorest/autorest/validation package and is used to validate 
        // constraints. 
        // See PR: https://github.com/Azure/go-autorest/tree/master/autorest/validation
        //
        /////////////////////////////////////////////////////////////////////////////////////////



        /// <summary>
        /// Return list of validations for primary, map, sequence and rest of the types.
        /// </summary>
        /// <param name="p"></param>
        /// <param name="name"></param>
        /// <param name="method"></param>
        /// <param name="isCompositeProperties"></param>
        /// <returns></returns>
        public static List<string> ValidateType(this IVariable p, string name, HttpMethod method,
            bool isCompositeProperties = false)
        {
            List<string> x = new List<string>();
            if (method != HttpMethod.Patch || !p.IsBodyParameter() || isCompositeProperties)
            {
                x.AddRange(p.Constraints.Select(c => GetConstraint(name, c.Key.ToString(), c.Value)).ToList());
            }

            List<string> y = new List<string>();
            if (x.Count > 0)
            {
                if (p.CheckNull() || isCompositeProperties)
                    y.AddRange(x.AddChain(name, NullConstraint, p.IsRequired));
                else
                    y.AddRange(x);
            }
            else
            {
                if (p.IsRequired && (p.CheckNull() || isCompositeProperties))
                    y.AddNullValidation(name, p.IsRequired);
            }
            return y;
        }

        /// <summary>
        /// Return list of validations for composite type.
        /// </summary>
        /// <param name="p"></param>
        /// <param name="name"></param>
        /// <param name="method"></param>
        /// <param name="ancestors"></param>
        /// <param name="isCompositeProperties"></param>
        /// <returns></returns>
        public static List<string> ValidateCompositeType(this IVariable p, string name, HttpMethod method, HashSet<string> ancestors,
            bool isCompositeProperties = false)
        {
            List<string> x = new List<string>();
            if (method != HttpMethod.Patch || !p.IsBodyParameter() || isCompositeProperties)
            {
                foreach (var prop in ((CompositeType)p.ModelType).Properties)
                {
                    var primary = prop.ModelType as PrimaryType;
                    var sequence = prop.ModelType as SequenceType;
                    var map = prop.ModelType as DictionaryTypeGo;
                    var composite = prop.ModelType as CompositeType;

                    // if this type was flattened use the name of the type instead of
                    // the property name as it's been embedded as an anonymous field
                    var propName = prop.Name;
                    if (prop.WasFlattened())
                        propName = prop.ModelType.Name;

                    if (primary != null || sequence != null || map != null)
                    {
                        x.AddRange(prop.ValidateType($"{name}.{propName}", method, true));
                    }
                    else if (composite != null)
                    {
                        if (ancestors.Contains(composite.Name))
                        {
                            x.AddNullValidation($"{name}.{propName}", p.IsRequired);
                        }
                        else
                        {
                            ancestors.Add(composite.Name);
                            x.AddRange(prop.ValidateCompositeType($"{name}.{propName}", method, ancestors, true));
                            ancestors.Remove(composite.Name);
                        }
                    }
                }
            }

            List<string> y = new List<string>();
            if (x.Count > 0)
            {
                if (p.CheckNull() || isCompositeProperties)
                    y.AddRange(x.AddChain(name, NullConstraint, p.IsRequired));
                else
                    y.AddRange(x);
            }
            else
            {
                if (p.IsRequired && (p.CheckNull() || isCompositeProperties))
                    y.AddNullValidation(name, p.IsRequired);
            }
            return y;
        }

        /// <summary>
        /// Add null validation in validation object.
        /// </summary>
        /// <param name="v"></param>
        /// <param name="name"></param>
        /// <param name="isRequired"></param>
        public static void AddNullValidation(this List<string> v, string name, bool isRequired = false)
        {
            v.Add(GetConstraint(name, NullConstraint, $"{isRequired}".ToLower()));
        }

        /// <summary>
        /// Add chain of validation for composite type.
        /// </summary>
        /// <param name="x"></param>
        /// <param name="name"></param>
        /// <param name="constraint"></param>
        /// <param name="isRequired"></param>
        /// <returns></returns>
        public static List<string> AddChain(this List<string> x, string name, string constraint, bool isRequired)
        {
            List<string> a = new List<string>
            {
                GetConstraint(name, constraint, $"{isRequired}".ToLower(), true),
                $"Chain: []validation.Constraint{{{x[0]}"
            };
            a.AddRange(x.GetRange(1, x.Count - 1));
            a.Add("}}");
            return a;
        }
        /// <summary>
        /// CheckNull 
        /// </summary>
        /// <param name="p"></param>
        /// <returns></returns>
        // Check if type is not a null or pointer type.
        public static bool CheckNull(this IVariable p)
        {
            return p is Parameter && (p.ModelType.IsNullValueType() || !(p.IsRequired || p.ModelType.CanBeEmpty()));
        }

        /// <summary>
        /// Check whether a type is nullable type.
        /// </summary>
        /// <param name="t"></param>
        /// <returns></returns>
        public static bool IsNullValueType(this IModelType t)
        {
            var dictionaryType = t as DictionaryType;
            var primaryType = t as PrimaryType;
            var sequenceType = t as SequenceType;

            return dictionaryType != null
                || (primaryType != null
                   && primaryType.KnownPrimaryType == KnownPrimaryType.ByteArray)
                || sequenceType != null;
        }

        /// <summary>
        /// Check if parameter is a body parameter.
        /// </summary>
        /// <param name="p"></param>
        /// <returns></returns>
        public static bool IsBodyParameter(this IVariable p)
        {
            return p is Parameter && ((Parameter)p).Location == ParameterLocation.Body;
        }

        /// <summary>
        /// Construct validation string for validation object for the passed constraint.
        /// </summary>
        /// <param name="name"></param>
        /// <param name="constraintName"></param>
        /// <param name="constraintValue"></param>
        /// <param name="chain"></param>
        /// <returns></returns>
        public static string GetConstraint(string name, string constraintName, string constraintValue, bool chain = false)
        {
            var value = constraintName == Constraint.Pattern.ToString()
                                          ? $"`{constraintValue}`"
                                          : constraintValue;
            return string.Format(chain
                                    ? "\t{{Target: \"{0}\", Name: validation.{1}, Rule: {2} "
                                    : "\t{{Target: \"{0}\", Name: validation.{1}, Rule: {2}, Chain: nil }}",
                                    name, constraintName, value);
        }
    }
}
