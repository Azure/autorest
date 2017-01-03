// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks {
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;
    using Microsoft.Perks.Linq;

    public static class TypeExtensions {
        private const BindingFlags AnyPropertyFlags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.FlattenHierarchy /* | BindingFlags.GetProperty */| BindingFlags.Instance;
        private const string JsonIgnoreAttribute = "JsonIgnoreAttribute";

        public static string ToTypesString(this Type[] types) => types?.Aggregate("", (current, type) => $"{current}, {type?.FullName ?? "«null»"}").Trim(',') ?? "";

        public static bool IsValueType(this Type type) => type.GetTypeInfo().IsValueType;
        public static bool IsEnum(this Type type) => type.GetTypeInfo().IsEnum;
        public static IEnumerable<T> GetCustomAttributes<T>(this Type type, bool inherit) where T : Attribute => type.GetTypeInfo().GetCustomAttributes<T>(inherit);
        public static Type BaseType(this Type type) => type.GetTypeInfo().BaseType;
        public static bool IsGenericType(this Type type) => type.GetTypeInfo().IsGenericType;
        public static IEnumerable<CustomAttributeData> CustomAttributes(this Type type) => type.GetTypeInfo().CustomAttributes;
        public static bool IsClass(this Type type) => type.GetTypeInfo().IsClass;

        public static Type[] ParameterTypes(this IEnumerable<ParameterInfo> parameterInfos) => parameterInfos?.Select(p => p.ParameterType).ToArray();

        public static Type[] ParameterTypes(this MethodBase method) => method?.GetParameters().ParameterTypes();

        public static bool IsMarked(this PropertyInfo property, string attributeTypeName)
            => property.GetCustomAttributes(true).Any(each => each.GetType().Name == attributeTypeName);

        public static bool IsGenericOf(this Type type, Type genericType)
            => type.IsGenericType() && type.GetGenericTypeDefinition() == genericType;

        private static IEnumerable<PropertyInfo> GetWriteableProperties(this Type type) {
            return type.GetProperties(AnyPropertyFlags).Where(each => !each.IsMarked(JsonIgnoreAttribute))
                .Select(each => GetWriteableProperty(type, each.Name))
                .WhereNotNull();
        }

        private static PropertyInfo GetWriteableProperty(this Type type, string propertyName) {
            if (type == null) {
                return null;
            }

            var pi = type.GetProperty(propertyName, AnyPropertyFlags);
            if (typeof(ICopyFrom).IsAssignableFrom(pi?.PropertyType) || typeof(IDictionary).IsAssignableFrom(pi?.PropertyType) || typeof(IList).IsAssignableFrom(pi?.PropertyType)) {
                return pi;
            }
            return true == pi?.CanWrite ? pi : GetWriteableProperty(type.BaseType(), propertyName);
        }

        private static PropertyInfo GetReadableProperty(this Type type, string propertyName) {
            if (type == null) {
                return null;
            }

            var pi = type.GetProperty(propertyName, AnyPropertyFlags);
            return true == pi?.CanRead ? pi : GetReadableProperty(type.BaseType(), propertyName);
        }

        public static TDestination LoadFrom<TDestination, TSource>(this TDestination destination, TSource source)
            where TDestination : class
            where TSource : class {
            if (destination == null) {
                throw new ArgumentNullException(nameof(destination));
            }

            if (source == null) {
                throw new ArgumentNullException(nameof(source));
            }

            var properties = destination.GetType().GetWriteableProperties();

            foreach (var destinationProperty in properties) {
                // skip items we've explicitly said not to copy.
                if (destinationProperty.IsMarked(JsonIgnoreAttribute)) {
                    continue;
                }

                // get the source property
                var sourceProperty = source.GetType().GetReadableProperty(destinationProperty.Name);
                if (sourceProperty == null || !sourceProperty.CanRead) {
                    continue;
                }

                var destinationType = destinationProperty.PropertyType;

                if (typeof(ICopyFrom).IsAssignableFrom(destinationType)) {
                    if (true == (destinationProperty.GetValue(destination) as ICopyFrom)?.CopyFrom(sourceProperty.GetValue(source, null))) {
                        continue;
                    }
                }

                // if the property is an IDictionary, clear the destination, and copy the key/values across
                if (typeof(IDictionary).IsAssignableFrom(destinationType)) {
                    var destinationDictionary = destinationProperty.GetValue(destination) as IDictionary;
                    if (destinationDictionary != null) {
                        var sourceDictionary = sourceProperty.GetValue(source, null) as IDictionary;
                        if (sourceDictionary != null) {
                            foreach (DictionaryEntry kv in sourceDictionary) {
                                destinationDictionary.Add(kv.Key, kv.Value);
                            }
                            continue;
                        }
                    }
                }

                // if the property is an IList, 
                if (typeof(IList).IsAssignableFrom(destinationType)) {
                    var destinationList = destinationProperty.GetValue(destination) as IList;
                    if (destinationList != null) {
                        var sourceValue = sourceProperty.GetValue(source, null) as IEnumerable;
                        if (sourceValue != null) {
                            foreach (var i in sourceValue) {
                                destinationList.Add(i);
                            }
                            continue;
                        }
                    }
                }

                if (destinationProperty.CanWrite) {
                    var sourceValue = sourceProperty.GetValue(source, null);

                    // this is a pretty weak assumption... (although, most of our collections should be ICopyFrom now.
                    if (destinationType.IsGenericType() && sourceValue is IEnumerable) {
                        var ctor = destinationType.GetConstructor(new[] {destinationType});
                        if (ctor != null) {
                            destinationProperty.SetValue(destination, ctor.Invoke(new[] {sourceValue}), null);
                            continue;
                        }
                    }

                    // set the target property value.
                    destinationProperty.SetValue(destination, sourceValue, null);
                }
            }
            return destination;
        }
    }
}