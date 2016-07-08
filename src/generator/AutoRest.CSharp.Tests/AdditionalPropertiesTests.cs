// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Reflection;
using Fixtures.AdditionalProperties.Models;
using Xunit;

namespace AutoRest.CSharp.Tests
{
    [Collection("AdditionalProperties Tests")]
    public class AdditionalPropertiesTests
    {
        [Fact]
        public void VerifyWithTypedDictionary()
        {
            // make sure it's constructable
            var withTypedDictionary = new WithTypedDictionary();
            Assert.NotNull(withTypedDictionary);

            // check to see if the JsonExtensionData attribute is on the member.
            var property = typeof(WithTypedDictionary).GetProperty("AdditionalProperties");
            Assert.NotNull(property);
            Assert.True(property.GetCustomAttributes().Any(each => each.GetType().Name == "JsonExtensionDataAttribute"));

            // check to see that the types of the AdditionalProperties object are correct
            var propertyType = property.PropertyType;
            Assert.Equal(new Type[] { typeof(string), typeof(Feature) }, propertyType.GenericTypeArguments);
        }

        [Fact]
        public void VerifyWithUntypedDictionary()
        {
            // make sure it's constructable
            var withUntypedDictionary = new WithUntypedDictionary();
            Assert.NotNull(withUntypedDictionary);

            // check to see if the JsonExtensionData attribute is on the member.
            var property = typeof(WithUntypedDictionary).GetProperty("AdditionalProperties");
            Assert.NotNull(property);
            Assert.True(property.GetCustomAttributes().Any(each => each.GetType().Name == "JsonExtensionDataAttribute"));

            // check to see that the types of the AdditionalProperties object are correct
            var propertyType = property.PropertyType;
            Assert.Equal(new Type[] { typeof(string), typeof(Object) }, propertyType.GenericTypeArguments);
        }

        [Fact]
        public void VerifyWithStringDictionary()
        {
            // make sure it's constructable
            var withStringDictionary = new WithStringDictionary();
            Assert.NotNull(withStringDictionary);

            // check to see if the JsonExtensionData attribute is on the member.
            var property = typeof(WithStringDictionary).GetProperty("AdditionalProperties");
            Assert.NotNull(property);
            Assert.True(property.GetCustomAttributes().Any(each => each.GetType().Name == "JsonExtensionDataAttribute"));

            // check to see that the types of the AdditionalProperties object are correct
            var propertyType = property.PropertyType;
            Assert.Equal(new Type[] { typeof(string), typeof(string) }, propertyType.GenericTypeArguments);
        }

    }
}
