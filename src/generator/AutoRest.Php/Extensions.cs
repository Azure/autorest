using AutoRest.Core.Model;
using AutoRest.Extensions.Azure;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace AutoRest.Php
{
    public static class Extensions
    {
        public static IEnumerable<T> Append<T>(this IEnumerable<T> seq, T value)
        {
            foreach (var i in seq)
            {
                yield return i;
            }
            yield return value;
        }

        public static IEnumerable<T> AppendIfNotNull<T>(this IEnumerable<T> seq, T value)
            where T : class
            => value == null ? seq : seq.Append(value);

        public static KeyValuePair<K, V> KeyValue<K, V>(this K key, V value)
            => new KeyValuePair<K, V>(key, value);

        public static ImmutableList<T> EmptyIfNull<T>(this ImmutableList<T> value)
            => value ?? ImmutableList<T>.Empty;

        public static IEnumerable<T> EmptyIfNull<T>(this IEnumerable<T> source)
            => source ?? Enumerable.Empty<T>();

        public static T UpCast<T>(this T value) => value;

        public static ItemInfo<T> WithItemInfo<T>(this T value, long count, bool isLast)
            => new ItemInfo<T>(value, count, isLast);

        public static IEnumerable<R> SelectWithInfo<T, R>(
            this IEnumerable<T> source,
            Func<ItemInfo<T>, R> map,
            R empty = default(R))
        {
            var count = -1L;
            var previous = default(T);
            foreach (var i in source)
            {
                if (count >= 0)
                {
                    yield return map(previous.WithItemInfo(count, false));
                }
                previous = i;
                ++count;
            }
            if (count >= 0)
            {
                yield return map(previous.WithItemInfo(count, true));
            }
            else
            {
                yield return empty;
            }
        }

        public static IEnumerable<R> SelectManyWithInfo<T, R>(
            this IEnumerable<T> source,
            Func<ItemInfo<T>, IEnumerable<R>> map,
            R empty = default(R))
            => source.SelectWithInfo(map, new[] { empty }).SelectMany(v => v);


        public static string Then(this bool p, string value)
            => p ? value : string.Empty;

        public static bool IsApiVersion(this Parameter p)
            => p.SerializedName == AzureExtensions.ApiVersion;
    }
}
