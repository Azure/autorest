// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Observable {
    using System;
    using System.Collections.Generic;

    public static class ObservableExtensions {
        public static ObservableAwaiter<T> GetAwaiter<T>(this IObservable<T> observable) => new ObservableAwaiter<T>(observable);

        public static IAwaitableEnumerable<T> ReEnumerable<T>(this IObservable<T> observable) {
            return new BlockingCollectionObserver<T>(observable);
        }

        public static IEnumerable<T> ToEnumerable<T>(this IObservable<T> observable) {
            return new EnumerableObserver<T>(observable);
        }
    }
}