// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Core.Utilities.Collections
{
    public static class LinqExtensions
    {
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

        public static IEnumerable<T> SingleItemAsEnumerable<T>(this T item) => new[] { item };

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