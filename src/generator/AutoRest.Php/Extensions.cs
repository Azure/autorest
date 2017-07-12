using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoRest.Php
{
    public static class Extensions
    {
        public static IEnumerable<T> EmptyIfNull<T>(this IEnumerable<T> value)
            => value ?? Enumerable.Empty<T>();
    }
}
