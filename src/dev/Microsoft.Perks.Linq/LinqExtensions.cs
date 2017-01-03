// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Linq {
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;

    public static class LinqExtensions {
        private static readonly MethodInfo _castMethod = typeof(Enumerable).GetMethod("Cast");
        private static readonly MethodInfo _toArrayMethod = typeof(Enumerable).GetMethod("ToArray");
        private static readonly IDictionary<Type, MethodInfo> _castMethods = new Dictionary<Type, MethodInfo>();
        private static readonly IDictionary<Type, MethodInfo> _toArrayMethods = new Dictionary<Type, MethodInfo>();

        /// <summary>
        ///     Returns a ReEnumerable wrapper around the collection which timidly (cautiously) pulls items
        ///     but still allows you to to re-enumerate without re-running the query.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="collection"></param>
        /// <returns></returns>
        public static MutableEnumerable<T> ReEnumerable<T>(this IEnumerable<T> collection) {
            if (collection == null) {
                return new ReEnumerable<T>(Enumerable.Empty<T>());
            }
            return collection as MutableEnumerable<T> ?? new ReEnumerable<T>(collection);
        }

        public static TSource SafeAggregate<TSource>(this IEnumerable<TSource> source, Func<TSource, TSource, TSource> func) {
            var src = source.ReEnumerable();
            if (source != null && src.Any()) {
                return src.Aggregate(func);
            }
            return default(TSource);
        }

        public static bool ContainsIgnoreCase(this IEnumerable<string> collection, string value) {
            if (collection == null) {
                return false;
            }
            return collection.Any(s => s.EqualsIgnoreCase(value));
        }

        public static bool ContainsAnyOfIgnoreCase(this IEnumerable<string> collection, params object[] values) {
            return collection.ContainsAnyOfIgnoreCase(values.Select(value => value == null ? null : value.ToString()));
        }

        public static bool ContainsAnyOfIgnoreCase(this IEnumerable<string> collection, IEnumerable<string> values) {
            if (collection == null) {
                return false;
            }
            var set = values.ReEnumerable();

            return collection.Any(set.ContainsIgnoreCase);
        }

        public static string JoinWithComma(this IEnumerable<string> items) => items.JoinWith(",");

        public static string JoinWith(this IEnumerable<string> items, string delimiter) => items.SafeAggregate((current, each) => current + delimiter + each);

        public static IEnumerable<TSource> FilterWithFinalizer<TSource>(this IEnumerable<TSource> source, Func<TSource, bool> predicate, Action<TSource> onFilterAction) {
            foreach (var i in source) {
                if (predicate(i)) {
                    onFilterAction(i);
                } else {
                    yield return i;
                }
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

        public static TValue AddOrSet<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, TValue value) {
            lock (dictionary) {
                if (dictionary.ContainsKey(key)) {
                    dictionary[key] = value;
                } else {
                    dictionary.Add(key, value);
                }
            }
            return value;
        }

        public static TValue GetOrAdd<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, Func<TValue> valueFunction) {
            lock (dictionary) {
                return dictionary.ContainsKey(key) ? dictionary[key] : dictionary.AddOrSet(key, valueFunction());
            }
        }

        /// <summary>
        ///     Concatenates a single item to an IEnumerable
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="enumerable"></param>
        /// <param name="item"></param>
        /// <returns></returns>
        public static IEnumerable<T> ConcatSingleItem<T>(this IEnumerable<T> enumerable, T item) =>
            enumerable.Concat(new[] {item});

        public static IEnumerable<T> WhereNotNull<T>(this IEnumerable<T> enumerable) => enumerable?.Where(each => (object)each != null) ?? Enumerable.Empty<T>();

        public static T FirstNotNull<T>(this IEnumerable<T> enumerable) => enumerable == null ? default(T) : enumerable.FirstOrDefault(each => each != null);

        public static IEnumerable<TResult> SelectNotNull<TSource, TResult>(this IEnumerable<TSource> enumerable, Func<TSource, TResult> selector) => enumerable?.Select(selector).WhereNotNull() ?? Enumerable.Empty<TResult>();

        public static IEnumerable<TResult> SelectManyNotNull<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<TResult>> selector) => source?.SelectMany(selector).WhereNotNull() ?? Enumerable.Empty<TResult>();

        public static IEnumerable<T> ToIEnumerable<T>(this IEnumerator<T> enumerator) {
            if (enumerator != null) {
                while (enumerator.MoveNext()) {
                    yield return enumerator.Current;
                }
            }
        }

        public static IEnumerable<T> Concat<T>(this IEnumerable<T> set1, IEnumerator<T> set2) {
            var s1 = set1 ?? Enumerable.Empty<T>();
            var s2 = set2 == null ? Enumerable.Empty<T>() : set2.ToIEnumerable();
            return s1.Concat(s2);
        }

        public static IEnumerable<T> SingleItemAsEnumerable<T>(this T item) => new[] { item };

        /// <summary>
        ///     returns the index position where the predicate matches the value
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="source"></param>
        /// <param name="predicate"></param>
        /// <returns></returns>
        public static int IndexWhere<T>(this IEnumerable<T> source, Func<T, int, bool> predicate) {
            if (source != null && predicate != null) {
                var index = -1;
                if (source.Any(element => predicate(element, ++index))) {
                    return index;
                }
            }
            return -1;
        }

        /// <summary>
        ///     returns the index position where the predicate matches the value
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="source"></param>
        /// <param name="predicate"></param>
        /// <returns></returns>
        public static int IndexWhere<T>(this IEnumerable<T> source, Func<T, bool> predicate) {
            if (source != null && predicate != null) {
                var index = -1;
                if (source.Any(element => {
                    ++index;
                    return predicate(element);
                })) {
                    return index;
                }
            }
            return -1;
        }

        public static void AddRangeLocked<T>(this List<T> list, IEnumerable<T> items) {
            if (list == null) {
                throw new ArgumentNullException("list");
            }
            lock (list) {
                list.AddRange(items);
            }
        }

        public static object ToIEnumerableT(this IEnumerable<object> enumerable, Type elementType) => 
            _castMethods.GetOrAdd(elementType, () => _castMethod.MakeGenericMethod(elementType)).Invoke(null, new object[] {enumerable});

        public static object ToArrayT(this IEnumerable<object> enumerable, Type elementType) {
            return _toArrayMethods.GetOrAdd(elementType, () => _toArrayMethod.MakeGenericMethod(elementType)).Invoke(null, new[] {enumerable.ToIEnumerableT(elementType)});
        }

        public static Dictionary<TKey, TElement> ToDictionaryNicely<TSource, TKey, TElement>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector, IEqualityComparer<TKey> comparer) {
            if (source == null) {
                throw new ArgumentNullException("source");
            }
            if (keySelector == null) {
                throw new ArgumentNullException("keySelector");
            }
            if (elementSelector == null) {
                throw new ArgumentNullException("elementSelector");
            }

            var d = new Dictionary<TKey, TElement>(comparer);
            foreach (var element in source) {
                d.AddOrSet(keySelector(element), elementSelector(element));
            }
            return d;
        }

        public static Dictionary<TKey, TElement> ToDictionaryNicely<TSource, TKey, TElement>(this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector) {
            if (source == null) {
                throw new ArgumentNullException("source");
            }
            if (keySelector == null) {
                throw new ArgumentNullException("keySelector");
            }
            if (elementSelector == null) {
                throw new ArgumentNullException("elementSelector");
            }

            var d = new Dictionary<TKey, TElement>();
            foreach (var element in source) {
                d.AddOrSet(keySelector(element), elementSelector(element));
            }
            return d;
        }

        public static IEnumerableDisposable<T> DisposeAsYouGo<T>(this IEnumerable<T> enumerable, IDisposable thisToo) => 
            new DisposeAsYouGoEnumerable<T>(enumerable, thisToo);

        public static IEnumerableDisposable<T> DisposeAsYouGo<T>(this IEnumerable<T> enumerable) => 
            new DisposeAsYouGoEnumerable<T>(enumerable);
    }
}