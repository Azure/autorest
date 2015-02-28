// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Xunit;

namespace Microsoft.Rest.ClientRuntime.Tests.Internals
{
    public class LazyDictionaryTest
    {
        [Fact]
        public void LazyByDefaultTest()
        {
            var lazyDictionary = new LazyDictionary<string, string>();
            var initialized = lazyDictionary.IsInitialized;
            Assert.False(initialized);
        }

        [Fact]
        public void LazyAddTest()
        {
            var lazyDictionary = new LazyDictionary<string, string>();
            lazyDictionary.Add("key", "value");
            var initialized = lazyDictionary.IsInitialized;
            Assert.True(initialized);
        }

        [Fact]
        public void LazyKeyAddTest()
        {
            var lazyDictionary = new LazyDictionary<string, string>();
            lazyDictionary["key"] = "value";
            var initialized = lazyDictionary.IsInitialized;
            Assert.True(initialized);
        }
    }
}
