// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;
#pragma warning disable CS3024 // Constraint type is not CLS-compliant
namespace AutoRest.Core.Utilities
{
    /// <summary>
    /// Provides useful extension methods to simplify common coding tasks.
    /// </summary>
    public static class Extensions
    {
        /// <summary>
        /// Maps an action with side effects over a sequence.
        /// </summary>
        /// <param name='sequence'>The sequence to map over.</param>
        /// <param name='action'>The action to map.</param>
        /// <typeparam name='T'>Type of elements in the sequence.</typeparam>
        public static void ForEach<T>(this IEnumerable<T> sequence, Action<T> action)
        {
            if (sequence == null)
            {
                throw new ArgumentNullException("sequence");
            }

            if (action == null)
            {
                throw new ArgumentNullException("action");
            }

            foreach (T element in sequence)
            {
                action(element);
            }
        }

        /// <summary>
        /// Returns a collection of the descendant elements for this collection.
        /// </summary>
        /// <typeparam name='T'>Type of elements in the sequence.</typeparam>
        /// <param name="items">Child collection</param>
        /// <param name="childSelector">Child selector</param>
        /// <returns>List of all items and descendants of each item</returns>
        [SuppressMessage("Microsoft.Design", "CA1006:DoNotNestGenericTypesInMemberSignatures", Justification = "By design.")]
        public static IEnumerable<T> Descendants<T>(this IEnumerable<T> items, Func<T, IEnumerable<T>> childSelector)
        {
            foreach (var item in items)
            {
                foreach (var childResult in childSelector(item).Descendants(childSelector))
                    yield return childResult;
                yield return item;
            }
        }

        /// <summary>
        ///     Determines whether the collection object is either null or an empty collection.
        /// </summary>
        /// <typeparam name="T"> </typeparam>
        /// <param name="collection"> The collection. </param>
        /// <returns>
        ///     <c>true</c> if [is null or empty] [the specified collection]; otherwise, <c>false</c> .
        /// </returns>
        /// <remarks>
        /// </remarks>
        public static bool IsNullOrEmpty<T>(this IEnumerable<T> collection) => collection == null || !collection.Any();

        /// <summary>
        /// Word wrap a string of text to a given width.
        /// </summary>
        /// <param name='text'>The text to word wrap.</param>
        /// <param name='width'>Width available to wrap.</param>
        /// <returns>Lines of word wrapped text.</returns>
        public static IEnumerable<string> WordWrap(this string text, int width)
        {
            Debug.Assert(text != null, "text should not be null.");

            var lines = text.Split(new [] {"\r\n", "\r", "\n"}, StringSplitOptions.None);
            foreach (var line in lines)
            {
                var processedLine = line.Trim();

                // yield empty lines as they are (probably) intensional
                if (processedLine.Length == 0)
                {
                    yield return processedLine;
                }

                // feast on the line until it's gone
                while (processedLine.Length > 0)
                {
                    // determine potential wrapping points
                    var whitespacePositions = Enumerable
                        .Range(0, processedLine.Length)
                        .Where(i => char.IsWhiteSpace(processedLine[i]))
                        .Concat(new [] { processedLine.Length })
                        .Cast<int?>();
                    var preWidthWrapAt = whitespacePositions.LastOrDefault(i => i <= width);
                    var postWidthWrapAt = whitespacePositions.FirstOrDefault(i => i > width);

                    // choose preferred wrapping point
                    var wrapAt = preWidthWrapAt ?? postWidthWrapAt ?? processedLine.Length;

                    // wrap
                    yield return processedLine.Substring(0, wrapAt);
                    processedLine = processedLine.Substring(wrapAt).Trim();
                }
            }
        }

        public static bool IsMarked<T>(this PropertyInfo property)
            => property.GetCustomAttributes(typeof(T), true).Any();

        public static bool IsGenericOf(this Type type, Type genericType)
            => type.IsGenericType && type.GetGenericTypeDefinition() == genericType;

        public static string ToTypesString(this Type[] types) => types?.Aggregate("", (current, type) => $"{current}, {type?.FullName ?? "«null»" }").Trim(',') ?? "";

        public static Type[] ParameterTypes(this IEnumerable<ParameterInfo> parameterInfos) => parameterInfos?.Select(p => p.ParameterType).ToArray();

        public static Type[] ParameterTypes(this MethodBase method) => method?.GetParameters().ParameterTypes();

        /// <summary>
        /// Performs shallow copy of properties from source into destination.
        /// </summary>
        /// <typeparam name="TDestination">Destination type</typeparam>
        /// <typeparam name="TSource">Source type</typeparam>
        /// <param name="destination">Destination object.</param>
        /// <param name="source">Source object.</param>
        [SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "U", Justification = "Common naming for generics.")]
        [SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "V", Justification = "Common naming for generics.")]
        public static TDestination LoadFrom<TDestination, TSource>(this TDestination destination, TSource source)
            where TDestination : class
            where TSource : class
        {
            if (destination == null)
            {
                throw new ArgumentNullException(nameof(destination));
            }

            if (source == null)
            {
                throw new ArgumentNullException(nameof(source));
            }

            var properties = destination.GetType().GetWriteableProperties();

            foreach (var destinationProperty in properties)
            {
                
                // skip items we've explicitly said not to copy.
                if ( destinationProperty.IsMarked<JsonIgnoreAttribute>())
                {
                    continue;
                }

                // get the source property
                var sourceProperty = source.GetType().GetReadableProperty(destinationProperty.Name);
                if (sourceProperty == null || !sourceProperty.CanRead)
                {
                    continue;
                }

                var destinationType = destinationProperty.PropertyType;


                if (typeof(ICopyFrom).IsAssignableFrom(destinationType))
                {
                    if (true == (destinationProperty.GetValue(destination) as ICopyFrom)?.CopyFrom(sourceProperty.GetValue(source, null)))
                    {
                        continue;
                    }
                }

                // if the property is an IDictionary, clear the destination, and copy the key/values across
                if (typeof(IDictionary).IsAssignableFrom(destinationType))
                {
                    var destinationDictionary = destinationProperty.GetValue(destination) as IDictionary;
                    if (destinationDictionary != null)
                    {
                        var sourceDictionary = sourceProperty.GetValue(source, null) as IDictionary;
                        if (sourceDictionary != null )
                        {
                            foreach (DictionaryEntry kv in sourceDictionary)
                            {
                                destinationDictionary.Add(kv.Key, kv.Value);
                            }
                            continue;
                        }
                    }
                   
                }

                // if the property is an IList, 
                if (typeof(IList).IsAssignableFrom(destinationType))
                {
                    var destinationList = destinationProperty.GetValue(destination) as IList;
                    if (destinationList != null)
                    {
                        var sourceValue = sourceProperty.GetValue(source, null) as IEnumerable;
                        if (sourceValue != null)
                        {
                            foreach (var i in sourceValue)
                            {
                                destinationList.Add(i);
                            }
                            continue;
                        }
                    }
                }

                if ( destinationProperty.CanWrite )
                {
                    var sourceValue = sourceProperty.GetValue(source, null);
                    

                    // this is a pretty weak assumption... (although, most of our collections should be ICopyFrom now.
                    if (destinationType.IsGenericType && sourceValue is IEnumerable)
                    {
                        var ctor = destinationType.GetConstructor(new[] { destinationType });
                        if (ctor != null)
                        {
                            destinationProperty.SetValue(destination, ctor.Invoke(new[] { sourceValue }), null);
                            continue;
                        }
                    }
                    
                    // set the target property value.
                    destinationProperty.SetValue(destination, sourceValue, null);
                }
            }
            return destination;
        }


        public static T? Get<T>(this IDictionary<string, object> dictionary, string key) where T : struct, IComparable, IConvertible

        {
            object value;

            if (dictionary.TryGetValue(key, out value))
            {
                if (typeof(T).IsEnum)
                {
                    return (T)Enum.Parse(typeof(T), value.ToString(), true);
                }

                if (value is T)
                {
                    return (T) value;
                }

                try
                {
                    return (T) Convert.ChangeType(value, typeof(T));
                }
                catch
                {
                    return null;
                }
            }
            return null;
        }

        public static T GetValue<T>(this IDictionary<string, object> dictionary, string key) where T:class
        {
            object value;
            if (dictionary.TryGetValue(key, out value))
            {
                if (value is T)
                {
                    return (T) value;
                }
                try
                {
                    return (T)Convert.ChangeType(value, typeof(T));
                }
                catch
                {
                    return null;
                }
            }
            return null;
        }

        private const BindingFlags AnyPropertyFlags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.FlattenHierarchy | BindingFlags.GetProperty | BindingFlags.Instance;

        private static PropertyInfo GetReadableProperty(this Type type, string propertyName)
        {
            if (type == null)
            {
                return null;
            }

            var pi = type.GetProperty(propertyName,AnyPropertyFlags);
            return true == pi?.CanRead ? pi : GetReadableProperty(type.BaseType, propertyName);
        }

        private static IEnumerable<PropertyInfo> GetWriteableProperties(this Type type)
        {
            return type.GetProperties(AnyPropertyFlags).Where(each => !each.IsMarked<JsonIgnoreAttribute>())
                    .Select(each => GetWriteableProperty(type, each.Name))
                    .WhereNotNull();
        }

        private static PropertyInfo GetWriteableProperty(this Type type, string propertyName)
        {
            if (type == null)
            {
                return null;
            }

            var pi = type.GetProperty(propertyName, AnyPropertyFlags);
            if (typeof(ICopyFrom).IsAssignableFrom(pi?.PropertyType) || typeof(IDictionary).IsAssignableFrom(pi?.PropertyType) || typeof(IList).IsAssignableFrom(pi?.PropertyType))
            {
                return pi;
            }
            return true == pi?.CanWrite ? pi : GetWriteableProperty(type.BaseType, propertyName);
        }
        

        /// <summary>
        /// Converts the specified string to a camel cased string.
        /// </summary>
        /// <param name="value">The string to convert.</param>
        /// <returns>The camel case string.</returns>
        public static string ToCamelCase(this string value) => CodeNamer.Instance.CamelCase(value);
        public static string ToCamelCase(this Fixable<string> value) => CodeNamer.Instance.CamelCase(value.Value);

        /// <summary>
        /// Converts the specified string to a pascal cased string.
        /// </summary>
        /// <param name="value">The string to convert.</param>
        /// <returns>The pascal case string.</returns>
        public static string ToPascalCase(this string value) => CodeNamer.Instance.PascalCase(value);
        public static string ToPascalCase(this Fixable<string> value) => CodeNamer.Instance.PascalCase(value.Value);

        /// <summary>
        /// Escape reserved characters in xml comments with their escaped representations
        /// </summary>
        /// <param name="comment">The xml comment to escape</param>
        /// <returns>The text appropriately escaped for inclusing in an xml comment</returns>
        public static string EscapeXmlComment(this string comment)
        {
            if (comment == null)
            {
                return null;
            }

            return new StringBuilder(comment)
                .Replace("&", "&amp;")
                .Replace("<", "&lt;")
                .Replace(">", "&gt;").ToString();
        }

        public static string EscapeXmlComment(this Fixable<string> comment) => EscapeXmlComment(comment.Value);

        /// <summary>
        /// Returns true if the type is a PrimaryType with KnownPrimaryType matching typeToMatch.
        /// </summary>
        /// <param name="type"></param>
        /// <param name="typeToMatch"></param>
        /// <returns></returns>
        public static bool IsPrimaryType(this IModelType type, KnownPrimaryType typeToMatch) => typeToMatch == (type as PrimaryType)?.KnownPrimaryType;

        /// <summary>
        /// Returns true if the <paramref name="type"/> is a PrimaryType with KnownPrimaryType matching <paramref name="typeToMatch"/>
        /// or a DictionaryType with ValueType matching <paramref name="typeToMatch"/> or a SequenceType matching <paramref name="typeToMatch"/>
        /// </summary>
        /// <param name="type"></param>
        /// <param name="typeToMatch"></param>
        /// <returns></returns>
        public static bool IsOrContainsPrimaryType(this IModelType type, KnownPrimaryType typeToMatch)
        {
            if (type == null)
            {
                return false;
            }

            if (type.IsPrimaryType(typeToMatch) ||
                type.IsDictionaryContainingType(typeToMatch) ||
                type.IsSequenceContainingType(typeToMatch))
            {
                return true;
            }
            return false;
        }

        /// <summary>
        /// Returns true if the <paramref name="type"/> is a DictionaryType with ValueType matching <paramref name="typeToMatch"/>
        /// </summary>
        /// <param name="type"></param>
        /// <param name="typeToMatch"></param>
        /// <returns></returns>
        public static bool IsDictionaryContainingType(this IModelType type, KnownPrimaryType typeToMatch)
        {
            DictionaryType dictionaryType = type as DictionaryType;
            PrimaryType dictionaryPrimaryType = dictionaryType?.ValueType as PrimaryType;
            return dictionaryPrimaryType != null && dictionaryPrimaryType.IsPrimaryType(typeToMatch);
        }

        /// <summary>
        /// Returns true if the <paramref name="type"/>is a SequenceType matching <paramref name="typeToMatch"/>
        /// </summary>
        /// <param name="type"></param>
        /// <param name="typeToMatch"></param>
        /// <returns></returns>
        public static bool IsSequenceContainingType(this IModelType type, KnownPrimaryType typeToMatch)
        {
            SequenceType sequenceType = type as SequenceType;
            PrimaryType sequencePrimaryType = sequenceType?.ElementType as PrimaryType;
            return sequencePrimaryType != null && sequencePrimaryType.IsPrimaryType(typeToMatch);
        }

        public static string StripControlCharacters(this string input)
        {
            return string.IsNullOrWhiteSpace(input) ? input : Regex.Replace(input, @"[\ca-\cz-[\cj\cm\ci]]", string.Empty);
        }

        public static string Capitalize(this string input)
        {
            if (string.IsNullOrWhiteSpace(input))
            {
                throw new ArgumentException("Input may not be null, empty, or whitespace.");
            }

            // if it's only one character
            if (input.Length == 1)
            {
                return input.ToUpper(CultureInfo.CurrentCulture);
            }

            //otherwise the first letter as uppercase, and the rest of the string unaltered.
            return $"{char.ToUpper(input[0], CultureInfo.CurrentCulture)}{input.Substring(1)}";
        }

        public static bool Equals(this Fixable<string> s1, string s2, StringComparison comparison) => ReferenceEquals(s1.Value, s2) || s1.Value.Equals(s2, comparison);
        public static bool Equals(this string s1, Fixable<string> s2, StringComparison comparison) => ReferenceEquals(s1, s2.Value) || s1.Equals(s2.Value, comparison);
        public static bool EqualsIgnoreCase(this Fixable<string> s1, string s2) => ReferenceEquals(s1.Value, s2) || true == s1.Value?.Equals(s2, StringComparison.OrdinalIgnoreCase);
        public static bool EqualsIgnoreCase(this string s1, Fixable<string> s2) => ReferenceEquals(s1,s2.Value) || s1.Equals(s2.Value, StringComparison.OrdinalIgnoreCase);
        public static bool EqualsIgnoreCase(this Fixable<string> s1, Fixable<string> s2) => ReferenceEquals(s1.Value, s2.Value) || s1.Value.Equals(s2.Value, StringComparison.OrdinalIgnoreCase);

        public static char CharAt(this Fixable<string> str, int index) => str.Value[index];
        public static string Substring(this Fixable<string> str, int startIndex) => str.Value.Substring(startIndex);

        public static string ToLower(this Fixable<string> str) => str?.Value.ToLowerInvariant();
        public static string ToLowerInvariant(this Fixable<string> str) => str?.Value.ToLowerInvariant();
        public static bool IsNullOrEmpty(this Fixable<string> str) => string.IsNullOrWhiteSpace(str?.Value);
        public static bool Contains( this Fixable<string> str, string contained) => true == str?.Value?.Contains(contained);
        public static bool Contains(this Fixable<string> str, char chr) => true == str?.Value?.Contains(chr);
        public static int IndexOf(this Fixable<string> str, string text) => str?.Value?.IndexOf(text,StringComparison.Ordinal) ?? -1;
        public static int IndexOf(this Fixable<string> str, char chr) => str?.Value?.IndexOf(chr) ?? -1;
        public static int IndexOfIgnoreCase(this Fixable<string> str, string text) => str?.Value?.IndexOf(text, StringComparison.OrdinalIgnoreCase) ?? -1;
        public static bool StartsWith(this Fixable<string> str, string startsWith) => true == str?.Value?.StartsWith(startsWith, StringComparison.Ordinal);
        public static bool StartsWithIgnoreCase(this Fixable<string> str, string startsWith) => true == str?.Value?.StartsWith(startsWith, StringComparison.OrdinalIgnoreCase);

        public static string EnsureEndsWith(this string str, string suffix) => string.IsNullOrEmpty(str) ? str : (str.EndsWith(suffix) ? str : str + suffix);
        public static string EnsureEndsWith(this Fixable<string> str, string suffix) => str.IsNullOrEmpty() ? str.Value : str.Value.EnsureEndsWith(suffix);

        public static string Else(this string preferred, string fallback) => string.IsNullOrWhiteSpace(preferred) ? fallback : preferred;

        public static string Else(this Fixable<string> preferred, string fallback) => string.IsNullOrWhiteSpace(preferred.Value) ? fallback : preferred.Value;
        public static string Else(this string preferred, Fixable<string> fallback) => string.IsNullOrWhiteSpace(preferred) ? fallback.Value : preferred;
        public static string Else(this Fixable<string> preferred, Fixable<string> fallback) => string.IsNullOrWhiteSpace(preferred.Value) ? fallback.Value : preferred.Value;
        public static string GetUniqueName(this IChild scope, string desiredName)
        {
            // current hack: get the methods params and add them to the local list.
            var names = new HashSet<string>((scope as Method)?.Parameters.Select(each => each.Name.Value) ?? Enumerable.Empty<string>());
            names.AddRange(scope.LocallyUsedNames);

            // get a unique name
            var result = CodeNamer.Instance.GetUnique(desiredName, scope, scope.Parent.IdentifiersInScope,
                scope.Parent.Children, names);

            
            // tell the child that they own that name now.
            scope?.LocallyUsedNames?.Add(result);
            return result;
        }

        public static string TrimStart(this Fixable<string> str, char ch) => str.Value.TrimStart(ch);
        public static string TrimEnd(this Fixable<string> str, char ch) => str.Value.TrimEnd(ch);


        public static void Disambiguate(this IEnumerable<IChild> children)
        {
            foreach (var child in children)
            {
                child.Disambiguate();
            }
        }
        public static Task<T> AsResultTask<T>(this T result)
        {
            var x = new TaskCompletionSource<T>(TaskCreationOptions.AttachedToParent);
            x.SetResult(result);
            return x.Task;
        }
        private static string[] LFOnly = new[] { ".py", ".rb", ".ts", ".js" };
        public static bool IsFileLineFeedOnly(this string filename) => LFOnly.Any(each => filename.EndsWith(each, StringComparison.OrdinalIgnoreCase));
        public static string LineEnding(this string filename) => filename.IsFileLineFeedOnly() ? "\n" : "\r\n";

        public static string AdjustGithubUrl(this string url) => Regex.Replace(url,
            @"^((http|https)\:\/\/)?github\.com\/(?<user>[^\/]+)\/(?<repo>[^\/]+)\/blob\/(?<branch>[^\/]+)\/(?<file>.+)$",
            @"https://raw.githubusercontent.com/${user}/${repo}/${branch}/${file}");
    }
}