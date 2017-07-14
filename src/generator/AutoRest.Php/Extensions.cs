using System;
using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php
{
    public static class Extensions
    {
        public static ImmutableList<T> EmptyIfNull<T>(this ImmutableList<T> value)
            => value ?? ImmutableList<T>.Empty;

        public static T UpCast<T>(this T value)
            => value;

        public static IEnumerable<R> Select<T, R>(
            this IEnumerable<T> source, Func<T, ItemInfo, R> map)
        {
            bool isFirst = true;
            bool hasPrevious = false;
            T previous = default(T);
            foreach (var item in source)
            {
                if (hasPrevious)
                {
                    yield return map(previous, new ItemInfo(isFirst, false));
                    isFirst = false;
                }
                previous = item;
                hasPrevious = true;
            }
            if (hasPrevious)
            {
                yield return map(previous, new ItemInfo(isFirst, true));
            }
        }
    }
}
