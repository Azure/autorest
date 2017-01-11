// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Threading.Tasks;

namespace AutoRest.Core.Utilities.Collections
{
    public static class LinqExtensions
    {
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
        public static MutableEnumerable<T> ReEnumerable<T>(this IEnumerable<T> collection)
        {
            if (collection == null)
            {
                return new ReEnumerable<T>(Enumerable.Empty<T>());
            }
            return collection as MutableEnumerable<T> ?? new ReEnumerable<T>(collection);
        }

        public static IEnumerable<TSource> FilterWithFinalizer<TSource>(this IEnumerable<TSource> source,
            Func<TSource, bool> predicate, Action<TSource> onFilterAction)
        {
            foreach (var i in source)
            {
                if (predicate(i))
                {
                    onFilterAction(i);
                }
                else
                {
                    yield return i;
                }
            }
        }



        public static TValue AddOrSet<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, TValue value)
        {
            lock (dictionary)
            {
                if (dictionary.ContainsKey(key))
                {
                    dictionary[key] = value;
                }
                else
                {
                    dictionary.Add(key, value);
                }
            }
            return value;
        }

        public static TValue GetOrAdd<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key,
            Func<TValue> valueFunction)
        {
            lock (dictionary)
            {
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
        public static IEnumerable<T> ConcatSingleItem<T>(this IEnumerable<T> enumerable, T item) => (enumerable ?? Enumerable.Empty<T>()).Concat(item.SingleItemAsEnumerable());
        public static IEnumerable<T> SingleItemConcat<T>(this T item, IEnumerable<T> enumerable) => item.SingleItemAsEnumerable() .Concat(enumerable ?? Enumerable.Empty<T>());

        public static IEnumerable<T> WhereNotNull<T>(this IEnumerable<T> enumerable) => enumerable?.Where(each => each != null) ?? Enumerable.Empty<T>();

        public static IEnumerable<T> ToIEnumerable<T>(this IEnumerator<T> enumerator)
        {
            while (true == enumerator?.MoveNext())
            {
                yield return enumerator.Current;
            }
        }

        public static IEnumerable<TResult> SelectMany<TResult>(this IDictionary source, Func<object,object,IEnumerable<TResult>> selector)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            if (selector == null) throw new ArgumentNullException(nameof(selector));
            var e = source.GetEnumerator();
            while (e.MoveNext())
            {
                foreach (TResult subElement in selector(e.Key, e.Value))
                {
                    yield return subElement;
                }
            }
        }

        public static IEnumerable<TResult> SelectMany<TResult>(this IEnumerable source, Func<object, IEnumerable<TResult>> selector)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            if (selector == null) throw new ArgumentNullException(nameof(selector));
            var e = source.GetEnumerator();
            while (e.MoveNext())
            {
                foreach (TResult subElement in selector(e.Current))
                {
                    yield return subElement;
                }
            }
        }

        public static IEnumerable<TResult> SelectMany<TResult>(this IEnumerable source, Func<object, int, IEnumerable<TResult>> selector)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            if (selector == null) throw new ArgumentNullException(nameof(selector));
            int index = -1;
            foreach( var item in source )
            {
                index++;
                foreach (TResult subElement in selector(item,index))
                {
                    yield return subElement;
                }
            }
        }


        public static IEnumerable<TResult> Select<TResult>(this IDictionary source, Func<object, object, TResult> selector)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            if (selector == null) throw new ArgumentNullException(nameof(selector));

            var e = source.GetEnumerator();
            while (e.MoveNext())
            {
                yield return selector( e.Key, e.Value);
            }
        }

        public static IEnumerable<TResult> Select<TResult>(this IEnumerable source, Func<object, TResult> selector)
        {
            if (source == null) throw new ArgumentNullException(nameof(source));
            if (selector == null) throw new ArgumentNullException(nameof(selector));

            var e = source.GetEnumerator();
            while (e.MoveNext())
            {
                yield return selector(e.Current);
            }
        }

        public static IEnumerable<T> Concat<T>(this IEnumerable<T> set1, IEnumerator<T> set2)
        {
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
        public static int IndexWhere<T>(this IEnumerable<T> source, Func<T, int, bool> predicate)
        {
            if (source != null && predicate != null)
            {
                var index = -1;
                if (source.Any(element => predicate(element, ++index)))
                {
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
        public static int IndexWhere<T>(this IEnumerable<T> source, Func<T, bool> predicate)
        {
            if (source != null && predicate != null)
            {
                var index = -1;
                if (source.Any(element =>
                {
                    ++index;
                    return predicate(element);
                }))
                {
                    return index;
                }
            }
            return -1;
        }

        public static void AddRangeLocked<T>(this List<T> list, IEnumerable<T> items)
        {
            if (list == null)
            {
                throw new ArgumentNullException(nameof(list));
            }
            lock (list)
            {
                list.AddRange(items);
            }
        }

        public static object ToIEnumerableT(this IEnumerable<object> enumerable, Type elementType) => 
            _castMethods.GetOrAdd(elementType, () => _castMethod.MakeGenericMethod(elementType))
            .Invoke(null, new object[] {enumerable});

        public static object ToArrayT(this IEnumerable<object> enumerable, Type elementType) => 
            _toArrayMethods.GetOrAdd(elementType, () => _toArrayMethod.MakeGenericMethod(elementType))
            .Invoke(null, new[] {enumerable.ToIEnumerableT(elementType)});

        public static void ParallelForEach<T>(this IEnumerable<T> enumerable, Action<T> action)
        {
            var items = enumerable.ReEnumerable();
            object first = items.FirstOrDefault();
            if (first != null)
            {
                object second = items.Skip(1).FirstOrDefault();
                if (second != null)
                {
                    Parallel.ForEach(items, new ParallelOptions
                    {
                        MaxDegreeOfParallelism = -1,
                        TaskScheduler = new ThreadPerTaskScheduler()
                    }, action);
                }
                else
                {
                    action(items.FirstOrDefault());
                }
            }
        }

        public static void SerialForEach<T>(this IEnumerable<T> enumerable, Action<T> action)
        {
            var items = enumerable.ReEnumerable();
            object first = items.FirstOrDefault();
            if (first != null)
            {
                object second = items.Skip(1).FirstOrDefault();
                if (second != null)
                {
                    foreach (var item in items)
                    {
                        action(item);
                    }
                }
                else
                {
                    action(items.FirstOrDefault());
                }
            } 
        }

        public static Dictionary<TKey, TElement> ToDictionaryNicely<TSource, TKey, TElement>(
            this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector,
            IEqualityComparer<TKey> comparer)
        {
            if (source == null)
            {
                throw new ArgumentNullException(nameof(source));
            }
            if (keySelector == null)
            {
                throw new ArgumentNullException(nameof(keySelector));
            }
            if (elementSelector == null)
            {
                throw new ArgumentNullException(nameof(elementSelector));
            }

            var dictionary = new Dictionary<TKey, TElement>(comparer);
            foreach (var element in source)
            {
                dictionary.AddOrSet(keySelector(element), elementSelector(element));
            }
            return dictionary;
        }

        public static Dictionary<TKey, TElement> ToDictionaryNicely<TSource, TKey, TElement>(
            this IEnumerable<TSource> source, Func<TSource, TKey> keySelector, Func<TSource, TElement> elementSelector)
        {
            if (source == null)
            {
                throw new ArgumentNullException(nameof(source));
            }
            if (keySelector == null)
            {
                throw new ArgumentNullException(nameof(keySelector));
            }
            if (elementSelector == null)
            {
                throw new ArgumentNullException(nameof(elementSelector));
            }

            var dictionary = new Dictionary<TKey, TElement>();
            foreach (var element in source)
            {
                dictionary.AddOrSet(keySelector(element), elementSelector(element));
            }
            return dictionary;
        }

        public static IDictionary<TKey, TElement> AddRange<TKey, TElement>(this IDictionary<TKey, TElement> destination, IDictionary<TKey, TElement> source) 
        {
            foreach (var constraint in source)
            {
                destination.Add(constraint.Key, constraint.Value);
            }
            return destination;
        }

        public static HashSet<T> AddRange<T>(this HashSet<T> destination, IEnumerable<T> source)
        {
            if (source != null)
            {
                foreach (var element in source)
                {
                    destination.Add(element);
                }
            }
            return destination;
        }

        public static IEnumerable<TSource> Distinct<TSource, TKey>(this IEnumerable<TSource> source, Func<TSource, TKey> selector)
        {
            var keys = new HashSet<TKey>();
            foreach (var each in source)
            {
                if (keys.Add(selector(each)))
                {
                    yield return each;
                }
            }
        }
    }
}