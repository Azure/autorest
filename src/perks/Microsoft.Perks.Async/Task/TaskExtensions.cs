// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Task {
    using System;
    using System.Runtime.CompilerServices;
    using System.Threading.Tasks;

    public static class TaskExtensions {
        public static TaskAwaiter GetAwaiter(this Action action) =>
            Task.Run(action).GetAwaiter();

        public static TaskAwaiter<T> GetAwaiter<T>(this Func<T> function) =>
            Task.Run(function).GetAwaiter();

        public static Task<T> ToResultTask<T>(this T obj) =>
            Task.FromResult(obj);

#if DISABLED
        /// <summary>
        ///     Executes an action on each item in the source enumerable in parallel (using a Task).
        ///     If the enumerable contains a single item; this will execute the single action synchronously in this thread.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="enumerable"></param>
        /// <param name="action"></param>
        public static void ParallelForEach<T>(this IEnumerable<T> enumerable, Action<T> action) {
            var items = enumerable.ReEnumerable();
            if (items.Any()) {
                try {
                    var first = items.First();
                    try {
                        var second = items.Skip(1).First();
                        // we have at least two items. Execute in parallel.
                        Parallel.ForEach(items, new ParallelOptions {
                            // MaxDegreeOfParallelism = -1,
                        }, action);
                    } catch (InvalidOperationException) {
                        // no second item; execute the action on just the first item
                        action(first);
                    }
                } catch (InvalidOperationException) {
                }
            }
        }

        /// <summary>
        ///     Executes an action on each item in the source enumerable serially.
        ///     If the enumerable contains a single item; this will execute the single action synchronously in this thread.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="enumerable"></param>
        /// <param name="action"></param>
        public static void SerialForEach<T>(this IEnumerable<T> enumerable, Action<T> action) {
            var items = enumerable.ReEnumerable();
            if (items.Any()) {
                try {
                    var first = items.First();
                    try {
                        var second = items.Skip(1).First();
                        // we have at least two items. Execute in parallel.
                        foreach (var i in items) {
                            action(i);
                        }
                    } catch (InvalidOperationException) {
                        // no second item; execute the action on just the first item
                        action(first);
                    }
                } catch (InvalidOperationException) {
                }
            }
        }
#endif
    }
}