// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Net.Http;
using Fixtures.MirrorPrimitives;
using Fixtures.MirrorPrimitives.Models;
using Fixtures.MirrorSequences;
using Fixtures.MirrorSequences.Models;
using Xunit;

namespace AutoRest.CSharp.Tests.Utilities
{
    public static class MirrorTestHelpers
    {
        public const string AddedHeader = "x-ms-header-capture";

        public static Product GenerateProduct()
        {
            return new Product
            {
                Boolean = true,
                ByteProperty = GenerateBytes(100),
                Date = DateTime.UtcNow,
                DoubleProperty = 3.14,
                FloatProperty = 2.03,
                IntProperty = 12,
                Integer = 65,
                LongProperty = 1000000,
                Number = 3.22,
                StringProperty = "Now is the time for all good men to come to the aid of their country",
                DateTime = DateTime.UtcNow,
                Uuid = new Guid("122F1443-D736-4C16-8207-06B978AA4FF9"),
                ByteArray =
                    new List<byte[]> { GenerateBytes(100), GenerateBytes(200), GenerateBytes(300), GenerateBytes(100) },
                Base64url = System.Text.Encoding.UTF8.GetBytes("Now is the time for all good men to come to the aid of their country")
            };
        }

        public static byte[] GenerateBytes(int size)
        {
            var rand = new Random();
            var myByte = new byte[size];
            rand.NextBytes(myByte);
            return myByte;
        }

        public static void ValidateProduct(Product expected, Product actual)
        {
            if (expected == null)
            {
                throw new ArgumentNullException("expected");
            }

            if (actual == null)
            {
                throw new ArgumentNullException("actual");
            }

            Assert.Equal(expected.Boolean, actual.Boolean);
            Assert.Equal(expected.ByteProperty, actual.ByteProperty);
            Assert.Equal(expected.Date.Value.Year, actual.Date.Value.Year);
            Assert.Equal(expected.Date.Value.Month, actual.Date.Value.Month);
            Assert.Equal(expected.Date.Value.Day, actual.Date.Value.Day);
            Assert.Equal(expected.DoubleProperty, actual.DoubleProperty);
            Assert.Equal(expected.FloatProperty, actual.FloatProperty);
            Assert.Equal(expected.IntProperty, actual.IntProperty);
            Assert.Equal(expected.Integer, actual.Integer);
            Assert.Equal(expected.LongProperty, actual.LongProperty);
            Assert.Equal(expected.Number, actual.Number);
            Assert.Equal(expected.StringProperty, actual.StringProperty);
            Assert.Equal(expected.DateTime, actual.DateTime);
            Assert.Equal(expected.Uuid, actual.Uuid);
            Assert.Equal(expected.Base64url, actual.Base64url);
            ValidateList(expected.ByteArray, actual.ByteArray, (s, t) => Assert.Equal(s, t));
        }

        public static void ValidatePet(Pet expected, Pet actual)
        {
            if (expected == null)
            {
                throw new ArgumentNullException("expected");
            }

            if (actual == null)
            {
                throw new ArgumentNullException("actual");
            }

            Assert.Equal(expected.Id, actual.Id);
            Assert.Equal(expected.Name, actual.Name);
            Assert.Equal(expected.Tag, actual.Tag);
            Assert.Equal(expected.Id, actual.Id);
        }

        public static void ValidateList<T>(IList<T> expected, IList<T?> actual, Action<T, T?> assertEqualAction)
            where T : struct
        {
            if (expected == null)
            {
                throw new ArgumentNullException("expected");
            }

            if (actual == null)
            {
                throw new ArgumentNullException("actual");
            }

            if (assertEqualAction == null)
            {
                throw new ArgumentNullException("assertEqualAction");
            }

            Assert.Equal(expected.Count, actual.Count);
            for (int i = 0; i < expected.Count; ++i)
                assertEqualAction(expected[i], actual[i]);
        }

        public static void ValidateList<T>(IList<T> expected, IList<T> actual, Action<T, T> assertEqualAction)
        {
            if (expected == null)
            {
                throw new ArgumentNullException("expected");
            }

            if (actual == null)
            {
                throw new ArgumentNullException("actual");
            }

            if (assertEqualAction == null)
            {
                throw new ArgumentNullException("assertEqualAction");
            }

            Assert.Equal(expected.Count, actual.Count);
            for (int i = 0; i < expected.Count; ++i)
                assertEqualAction(expected[i], actual[i]);
        }


        public static Func<string> CreateErrorBody(Error error)
        {
            Assert.NotNull(error);
            return () => string.Format( CultureInfo.InvariantCulture, 
                "{{\"code\": {0}, \"message\": \"{1}\", \"fields\": \"{2}\"}}", error.Code,
                error.Message, error.Fields);
        }

        public static SwaggerDataTypesClient CreateDataClient()
        {
            return CreateDataClient(new MirroringHandler());
        }

        public static SwaggerDataTypesClient CreateDataClient(DelegatingHandler handler)
        {
            return new SwaggerDataTypesClient(handler);
        }

        public static SequenceRequestResponseTest CreateSequenceClient()
        {
            return new SequenceRequestResponseTest(new MirroringHandler());
        }
    }
}