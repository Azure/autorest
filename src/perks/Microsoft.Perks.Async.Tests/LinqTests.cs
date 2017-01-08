// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Tests {
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Perks.Linq;
    using Xunit;

    public class LinqTests {
        [Fact]
        public void TestDisposeAsYouGo_Any() {
            lock (typeof(SimpleDisposable)) {
                // ensure we're starting clean
                SimpleDisposable.Reset();

                var items = SimpleDisposable.GetSome(10).DisposeAsYouGo();

                // should call the DAYG 'any'
                Assert.True(items.Any());

                if (items.Any()) {
                    // once you start you have to either enumerate the collection
                    // or dispose of the enumerable.
                    items.Dispose();
                }

                var more = SimpleDisposable.GetSome(0).DisposeAsYouGo();

                // should not find any items.
                Assert.False(more.Any());

                // I've used Any(), but nothing was found. 
                // I should still dispose of more, but nothing was created.

                // we can see that everything disposable that was created, has been disposed
                Assert.False(SimpleDisposable.UndisposedItems.Any());
            }
        }

        [Fact]
        public void TestDisposeAsYouGo_AnyAndEnumerate() {
            lock (typeof(SimpleDisposable)) {
                // ensure we're starting clean
                SimpleDisposable.Reset();

                var items = SimpleDisposable.GetSome(10).DisposeAsYouGo();

                // should call the DAYG 'any'
                Assert.True(items.Any());

                if (items.Any()) {
                    // once you start you have to either enumerate the collection
                    // or dispose of the enumerable.
                    foreach (var i in items) {
                        Console.Write($"each : {i.Number}   ");
                    }
                    Console.WriteLine();
                }

                // we can see that a disposable was created, and by disposing of the enumerable
                // we have cleaned up.
                Assert.False(SimpleDisposable.UndisposedItems.Any());
            }
        }

        [Fact]
        public void TestDisposeAsYouGo_AnyWithDisposeAfterIsOkWhenProperlyUsed() {
            lock (typeof(SimpleDisposable)) {
                // ensure we're starting clean
                SimpleDisposable.Reset();

                // but if we add something to dispose after, we should have disposed of the collection
                using (var evenmore = SimpleDisposable.GetSome(0).DisposeAsYouGo(new SimpleDisposable())) {
                    // still no items.
                    Assert.False(evenmore.Any());
                }

                // we can see that everything disposable that was created, has been disposed
                Assert.False(SimpleDisposable.UndisposedItems.Any());
            }
        }

        [Fact]
        public void TestDisposeAsYouGo_AnyWithDisposeAfterLeaksWhenImproperlyUsed() {
            lock (typeof(SimpleDisposable)) {
                // ensure we're starting clean
                SimpleDisposable.Reset();

                // but if we add something to dispose after, we should have disposed of the collection
                var evenmore = SimpleDisposable.GetSome(0).DisposeAsYouGo(new SimpleDisposable());

                // still no items.
                Assert.False(evenmore.Any());

                // we can see that a disposable was created and nobody cared.
                Assert.True(SimpleDisposable.UndisposedItems.Any());
            }
        }

        [Fact]
        public void TestDisposeAsYouGo_Enumerate() {
            lock (typeof(SimpleDisposable)) {
                // ensure we're starting clean
                SimpleDisposable.Reset();

                var items = SimpleDisposable.GetSome(10).DisposeAsYouGo();

                // once you start you have to either enumerate the collection
                // or dispose of the enumerable.
                foreach (var i in items) {
                    Console.Write($"each : {i.Number}   ");
                }
                Console.WriteLine();

                // we can see that a disposable was created, and by disposing of the enumerable
                // we have cleaned up.
                Assert.False(SimpleDisposable.UndisposedItems.Any());
            }
        }

        [Fact]
        public void TestDisposeAsYouGo_OtherCases() {
            lock (typeof(SimpleDisposable)) {
                // ensure we're starting clean
                SimpleDisposable.Reset();

                var items = SimpleDisposable.GetSome(0).DisposeAsYouGo();

                // once you start you have to either enumerate the collection
                // or dispose of the enumerable.
                foreach (var i in items) {
                    Console.Write($"each : {i.Number}   ");
                }
                Console.WriteLine();

                // we can see that a disposable was created, and by disposing of the enumerable
                // we have cleaned up.
                Assert.False(SimpleDisposable.UndisposedItems.Any());
            }
        }

        [Fact]
        public void TestDisposeAsYouGo_WorksWithNonDisposableToo() {
            lock (typeof(SimpleDisposable)) {
                // ensure we're starting clean
                SimpleDisposable.Reset();

                // it's safe to use on non-disposable enumerables too.
                using (var items = new[] {"each", "item", "is", "fun"}.DisposeAsYouGo()) {
                    // Should be some items.
                    Assert.True(items.Any());
                }

                // we can see that everything disposable that was created, has been disposed
                Assert.False(SimpleDisposable.UndisposedItems.Any());

                // because you might have something to dispose of after the collection is run.
                using (var items = new[] {"each", "item", "is", "fun"}.DisposeAsYouGo(new SimpleDisposable())) {
                    // Should be some items.
                    Assert.True(items.Any());
                }

                // we can see that everything disposable that was created, has been disposed
                Assert.False(SimpleDisposable.UndisposedItems.Any());

                var didItWork = false;
                // any disposable can be used on the tail end.
                using (var items = new[] {"each", "item", "is", "fun"}.DisposeAsYouGo(new OnDispose(() => {didItWork = true;}))) {
                    // Should be some items.
                    Assert.True(items.Any());
                }

                Assert.True(didItWork);
            }
        }

        [Fact]
        public void TestLeakOfIDisposable() {
            lock (typeof(SimpleDisposable)) {
                // ensure we're starting clean
                SimpleDisposable.Reset();

                var items = SimpleDisposable.GetSome(10);

                // show that this would normally leak
                Assert.True(items.Any());

                // we can see that a disposable was created and nobody cared.
                Assert.True(SimpleDisposable.UndisposedItems.Any());
            }
        }
    }

    internal class SimpleDisposable : IDisposable {
        private static readonly List<SimpleDisposable> _items = new List<SimpleDisposable>();
        private static int _counter;
        public readonly int Number;

        public SimpleDisposable() {
            Number = _counter++;
            _items.Add(this);
        }

        public bool IsDisposed {get; private set;}

        public static IEnumerable<SimpleDisposable> UndisposedItems => _items.Where(each => !each.IsDisposed);

        public void Dispose() {
            if (IsDisposed) {
                throw new ObjectDisposedException("Should not be disposed twice. ");
            }
            IsDisposed = true;
        }

        public static IEnumerable<SimpleDisposable> GetSome(int number) {
            while (number > 0) {
                number--;
                yield return new SimpleDisposable();
            }
        }

        public static void Reset() {
            foreach (var i in _items) {
                if (!i.IsDisposed) {
                    i.Dispose();
                }
            }
            _items.Clear();
        }
    }
}