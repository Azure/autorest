using System.Collections.Immutable;

namespace AutoRest.Php
{
    public static class Extensions
    {
        public static ImmutableList<T> EmptyIfNull<T>(this ImmutableList<T> value)
            => value ?? ImmutableList<T>.Empty;

        public static T UpCast<T>(this T value)
            => value;
    }
}
