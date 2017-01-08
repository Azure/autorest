// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Perks.Async.Tests {
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Linq;
    using Observable;
    using Xunit;

#pragma warning disable 1998

    public class SelectTests {
        public async void TestSelectAsync() {
            IEnumerable<string> strings = new[] {"Garrett", "Garrett"};

            // each item in the source collection spins off an async task that should go the results.
            var results = strings.SelectAsync(each => {return each.ToLower();});

            // wait until the results are fully finished before continuing
            await results;

            Assert.True(results.ToArray().SequenceEqual(new[] {"garrett", "garrett"}));
        }

        [Fact]
        public void InitialTest() {
            Assert.True(true, "Make sure tests run");
        }

        [Fact]
        public async void TestAwaitIObservable() {
            var collection = new SimpleObservable();
            IObservable<string> foo = collection;
            collection.Start();

            Console.WriteLine($"Time: {DateTime.Now}");
            await foo;

            Console.WriteLine($"Time: {DateTime.Now}");

            Assert.True(true);
        }

        [Fact]
        public async void TestIObservableToEnumerable() {
            var collection = new SimpleObservable();
            var results = collection.ToEnumerable();
            collection.Start();

            Assert.True(results.SequenceEqual(new[] {"number: 0", "number: 1", "number: 2", "number: 3", "number: 4", "number: 5", "number: 6", "number: 7", "number: 8", "number: 9"}));
        }

        [Fact]
        public async void TestIObservableToEnumerableFirstOrDefault() {
            var collection = new SimpleObservable();
            var results = collection.ToEnumerable();
            collection.Start();
            Assert.Equal("number: 0", results.FirstOrDefault());
        }

        [Fact]
        public async void TestIObservableToEnumerableToArray() {
            var collection = new SimpleObservable();
            var results = collection.ToEnumerable();
            collection.Start();

            results = results.ToArray();
            Assert.True(results.SequenceEqual(new[] {"number: 0", "number: 1", "number: 2", "number: 3", "number: 4", "number: 5", "number: 6", "number: 7", "number: 8", "number: 9"}));
        }

        [Fact]
        public async void TestIObservableToReEnumerable() {
            var collection = new SimpleObservable();
            var results = collection.ReEnumerable();
            collection.Start();

            Assert.True(results.SequenceEqual(new[] {"number: 0", "number: 1", "number: 2", "number: 3", "number: 4", "number: 5", "number: 6", "number: 7", "number: 8", "number: 9"}));
        }

        [Fact]
        public void TestSelectAsyncAutoOnIEnumerable() {
            IEnumerable<string> strings = new[] {"Garrett", "Garrett"};

            // each item in the source collection spins off an async task that should go the results.
            var results = strings.SelectAsync(each => {return each.ToLower();});

            Assert.True(results.ToArray().SequenceEqual(new[] {"garrett", "garrett"}));
        }

        [Fact]
        public void TestSelectAsyncOnIEnumerableTask() {
            IEnumerable<string> strings = new[] {"Garrett", "Garrett"};

            // each item in the source collection spins off an async task that should go the results.
            var results = strings.SelectAsync(each => Task.Factory.StartNew(() => {return each.ToLower();}));

            // note: order of tasks returned is not guaranteed. (since some tasks may take longer than others)

            Assert.True(results.ToArray().SequenceEqual(new[] {"garrett", "garrett"}));
        }
    }
}