// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Linq {
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Runtime.CompilerServices;
    using System.Threading.Tasks;
    using Collections;

    public static class LinqExtensions {
        public static TaskAwaiter GetAwaiter(this IEnumerable<Task> tasks) => Task.WhenAll(tasks).GetAwaiter();

        public static IAwaitableEnumerable<T> GetAwaiter<T>(this IAwaitableEnumerable<T> awaitableEnumerable) => awaitableEnumerable;

        /// <summary>
        ///     Given an IEnumerable, Asnychronously (using a new Task) perform a Select
        ///     acress all nodes, each result Select'd using an asnychronous selector.
        ///     Note: this will return the resultant IEnumerable immediately, and begin queuing results in the background.
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="source"></param>
        /// <param name="selector"></param>
        /// <returns></returns>
        public static IAwaitableEnumerable<TResult> AsyncSelect<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, Task<TResult>> selector) {
            var results = new BlockingCollection<TResult>();
            Task.Factory.StartNew(() => {Task.WhenAll(source.Select(each => selector(each).ContinueWith(antecedent => results.Add(antecedent.Result)))).ContinueWith(antecedent => results.CompleteAdding());});
            return results;
        }

        /// <summary>
        ///     Given an IEnumerable, Asnychronously (using a new Task) perform a Select
        ///     acress all nodes, each result Select'd asynchronously using an new Task where the selector is run.
        ///     Note: this will return the resultant IEnumerable immediately, and begin queuing results in the background.
        /// </summary>
        public static IAwaitableEnumerable<TResult> AsyncSelect<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector) {
            var results = new BlockingCollection<TResult>();
            Task.Factory.StartNew(() => {
                foreach (var result in source.Select(selector)) {
                    results.Add(result);
                }
                results.CompleteAdding();
            });
            return results;
        }

        /// <summary>
        ///     Given an IEnumerable, Asnychronously (using a new Task) perform a SelectMany
        ///     acress all nodes, each result SelectMany'd using an asnychronous selector.
        ///     Note: this will return the resultant IEnumerable immediately, and begin queuing results in the background.
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="source"></param>
        /// <param name="selector"></param>
        /// <returns></returns>
        public static IAwaitableEnumerable<TResult> AsyncSelectMany<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<TResult>> selector) {
            var results = new BlockingCollection<TResult>();
            Task.Factory.StartNew(() => {
                var all = source.Select(s => Task.Factory.StartNew(() => selector(s)));
                Task.WhenAll(all).ContinueWith(antecedent => results.CompleteAdding());
            });
            return results;
        }

        /// <summary>
        ///     Given an IEnumerable, Asnychronously (using a new Task) perform a SelectMany
        ///     acress all nodes, each result SelectMany'd using an asnychronous selector.
        ///     Note: this will return the resultant IEnumerable immediately, and begin queuing results in the background
        ///     (asynchronously).
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="source"></param>
        /// <param name="selector"></param>
        /// <returns></returns>
        public static IAwaitableEnumerable<TResult> AsnycSelectMany<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<Task<TResult>>> selector) {
            var results = new BlockingCollection<TResult>();
            // we'd want to use startnew if the iteration on the original enumerable wasn't entirely snappy.
            Task.Factory.StartNew(() => {
                var all = source.Select(each => Task.WhenAll(selector(each).Select(task => task.ContinueWith(a => results.Add(a.Result)))));
                Task.WhenAll(all).ContinueWith(allTasks => results.CompleteAdding());
            });

            return results;
        }

        /// <summary>
        ///     Given an IEnumerable, perform a Select acress all nodes, each result
        ///     Select'd using an asnychronous selector.
        ///     Note: this will block until evaluation of the specified source is completed,
        ///     then return the resultant IEnumerable and begin queuing results in the background (asynchronously).
        ///     Note: order of returned items is not deterministic.
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="source"></param>
        /// <param name="selector"></param>
        /// <returns></returns>
        public static IAwaitableEnumerable<TResult> SelectAsync<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, Task<TResult>> selector) {
            var results = new BlockingCollection<TResult>();
            Task.WhenAll(source.Select(each => selector(each).ContinueWith(antecedent => results.Add(antecedent.Result)))).ContinueWith(antecedent => results.CompleteAdding());
            return results;
        }

        /// <summary>
        ///     Given an IEnumerable, perform a Select acress all nodes, each result
        ///     Select'd asnychronous executing the selector in a seperate Task.
        ///     Note: this will block until evaluation of the specified source is completed,
        ///     then return the resultant IEnumerable and begin queuing results in the background (asynchronously).
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="source"></param>
        /// <param name="selector"></param>
        /// <returns></returns>
        public static IAwaitableEnumerable<TResult> SelectAsync<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, TResult> selector) {
            var results = new BlockingCollection<TResult>();
            Task.WhenAll(source.Select(each => Task.Factory.StartNew(() => selector(each)).ContinueWith(antecedent => results.Add(antecedent.Result)))).ContinueWith(antecedent => results.CompleteAdding());
            return results;
        }

        /// <summary>
        ///     Given an IEnumerable, perform a SelectMany acress all nodes, each result SelectMany'd using an asnychronous
        ///     selector.
        ///     Note: this will block until evaluation of the specified source is completed,
        ///     then return the resultant IEnumerable and begin queuing results in the background (asynchronously).
        /// </summary>
        /// <typeparam name="TSource"></typeparam>
        /// <typeparam name="TResult"></typeparam>
        /// <param name="source"></param>
        /// <param name="selector"></param>
        /// <returns></returns>
        public static IAwaitableEnumerable<TResult> SelectManyAsync<TSource, TResult>(this IEnumerable<TSource> source, Func<TSource, IEnumerable<Task<TResult>>> selector) {
            var results = new BlockingCollection<TResult>();
            var all = source.Select(each => Task.WhenAll(selector(each).Select(task => task.ContinueWith(a => results.Add(a.Result)))));
            Task.WhenAll(all).ContinueWith(allTasks => results.CompleteAdding());
            return results;
        }
    }
}