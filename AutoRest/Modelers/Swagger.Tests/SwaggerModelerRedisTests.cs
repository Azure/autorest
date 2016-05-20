// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.IO;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp;
using Microsoft.Rest.Generator.Extensibility;
using Microsoft.Rest.Generator.Utilities;
using Xunit;
using Newtonsoft.Json.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Tests
{
    [Collection("AutoRest Tests")]
    public class SwaggerModelerRedisTests
    {
        [Fact]
        public void RedisResponseWithAccessKeys_IsAssignableTo_RedisResponse()
        {
            Generator.Modeler modeler = new SwaggerModeler(new Settings
            {
                Namespace = "Test",
                Input = Path.Combine("Swagger", "swagger-redis-sample.json")
            });
            var clientModel = modeler.Build();
            var redisResponseModel = clientModel.ModelTypes.Single(x => x.Name == "RedisResource");
            var redisResponseWithAccessKeyModel = clientModel.ModelTypes.Single(x => x.Name == "RedisResourceWithAccessKey");
            Assert.Equal(redisResponseModel, redisResponseWithAccessKeyModel.BaseModelType);
        }
    }
}