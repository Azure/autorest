// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks {
    using System;

    public static class CompareExtensions {
        public static bool WithCompareResult(this int result, Func<bool> onLess, Func<bool> onMore, Func<bool> onEqual) => 
            result < 0 ? onLess() : (result > 0 ? onMore() : onEqual());

        public static bool WithCompareResult(this int result, bool lessResult, bool moreResult, bool equalResult) => 
            result < 0 ? lessResult : (result > 0 ? moreResult : equalResult);

        public static int WithCompareResult(this int result, int lessResult, int moreResult, int equalResult) => 
            result < 0 ? lessResult : (result > 0 ? moreResult : equalResult);
    }
}