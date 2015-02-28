// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Xunit;

namespace Microsoft.Rest.ClientRuntime.Tests.Internals
{
    public class LazyListTest
    {
        [Fact]
        public void LazyByDefaultTest()
        {
            var lazyList = new LazyList<string>();
            var initialized = lazyList.IsInitialized;
            Assert.False(initialized);
        }

        [Fact]
        public void LazyAddTest()
        {
            var lazyList = new LazyList<string>();
            lazyList.Add("item");
            var initialized = lazyList.IsInitialized;
            Assert.True(initialized);
        }
    }
}
