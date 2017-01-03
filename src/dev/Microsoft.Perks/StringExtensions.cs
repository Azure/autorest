// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks {
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text.RegularExpressions;

    public static class StringExtensions {
        // ReSharper disable InconsistentNaming
        public static IEnumerable<string> Quote(this IEnumerable<string> items) => items.Select(each => "'{each}'");

        public static bool IsTrue(this string text) => 
            !string.IsNullOrWhiteSpace(text) && 
            text.Equals("true", StringComparison.CurrentCultureIgnoreCase);

        public static bool? IsTrueNullable(this string text) =>
            text == null ?
                (bool?)null :
                !string.IsNullOrWhiteSpace(text) && text.Equals("true", StringComparison.CurrentCultureIgnoreCase);

        public static bool EqualsIgnoreCase(this string str, string str2) =>
            str == null && str2 == null ||
            str != null && str2 != null &&
            str.Equals(str2, StringComparison.OrdinalIgnoreCase);

        public static string MakeSafeFileName(this string input) =>
            new Regex(@"-+").Replace(new Regex(@"[^\d\w\[\]_\-\.\ ]").Replace(input, "-"), "-").Replace(" ", "");
    }
}