// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using Xunit;
using Microsoft.Rest.TransientFaultHandling;

namespace Microsoft.Rest.ClientRuntime.Tests.TransientFaultHandling
{
    public class RetryConditionTest
    {
        [Fact]
        public void PropertiesAreSetByConstrutor()
        {
            RetryCondition condition = new RetryCondition(true, TimeSpan.FromSeconds(1));
            Assert.Equal(true, condition.RetryAllowed);
            Assert.Equal(TimeSpan.FromSeconds(1), condition.DelayBeforeRetry);

            condition = new RetryCondition(false, TimeSpan.Zero);
            Assert.Equal(false, condition.RetryAllowed);
            Assert.Equal(TimeSpan.Zero, condition.DelayBeforeRetry);
        }
    }
}
