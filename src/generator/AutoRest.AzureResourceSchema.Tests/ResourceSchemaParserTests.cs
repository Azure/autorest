// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using Xunit;

namespace AutoRest.AzureResourceSchema.Tests
{
    public class ResourceSchemaParserTests
    {
        [Fact]
        public void ParseWithServiceClientWithCreateResourceMethod()
        {
            ServiceClient serviceClient = new ServiceClient();

            serviceClient.ApiVersion = "2016-01-01";

            Parameter body = new Parameter()
            {
                Location = ParameterLocation.Body,
                Type = new CompositeType(),
            };

            CompositeType responseBody = new CompositeType();
            responseBody.Extensions.Add("x-ms-azure-resource", true);

            const string url = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Mock.Provider/mockResourceNames/{mockResourceName}";

            Method method = new Method()
            {
                HttpMethod = HttpMethod.Put,
                ReturnType = new Response(responseBody, null),
                Url = url,
            };
            method.Parameters.Add(body);

            serviceClient.Methods.Add(method);

            IDictionary<string, ResourceSchema> schemas = ResourceSchemaParser.Parse(serviceClient);
            Assert.NotNull(schemas);
            Assert.Equal(1, schemas.Count);

            ResourceSchema schema = schemas["Mock.Provider"];
            Assert.Equal("http://schema.management.azure.com/schemas/2016-01-01/Mock.Provider.json#", schema.Id);
            Assert.Equal("http://json-schema.org/draft-04/schema#", schema.Schema);
            Assert.Equal("Mock.Provider", schema.Title);
            Assert.Equal("Mock Provider Resource Types", schema.Description);
            Assert.Equal(1, schema.ResourceDefinitions.Count);
            Assert.Equal("mockResourceNames", schema.ResourceDefinitions.Keys.Single());
            Assert.Equal(
                new JsonSchema()
                {
                    JsonType = "object",
                    Description = "Mock.Provider/mockResourceNames"
                }
                .AddProperty("type", JsonSchema.CreateStringEnum("Mock.Provider/mockResourceNames"), true)
                .AddProperty("apiVersion", JsonSchema.CreateStringEnum("2016-01-01"), true),
                schema.ResourceDefinitions["mockResourceNames"]);
            Assert.NotNull(schema.Definitions);
            Assert.Equal(0, schema.Definitions.Count);
        }
    }
}
