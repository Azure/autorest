using System.IO;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;
using Xunit;

namespace AutoRest.CSharp.Tests
{
    public class SerializationTests
    {
        [Fact]
        public void ParseJsonSwagger_SecurityDefinitionType()
        {
            var swaggerContent = File.ReadAllText(@"Swagger\swagger.2.0.example.v2.json");
            var definition = SwaggerParser.Parse(swaggerContent);
            Assert.Equal(SecuritySchemeType.OAuth2, definition.SecurityDefinitions["petstore_auth"].SecuritySchemeType);
            Assert.Equal(SecuritySchemeType.ApiKey, definition.SecurityDefinitions["api_key"].SecuritySchemeType);
        }

        [Fact]
        public void ParseYamlSwagger_SecurityDefinitionType()
        {
            var swaggerContent = File.ReadAllText(@"Swagger\swagger.2.0.example.v2.yaml");
            var definition = SwaggerParser.Parse(swaggerContent);
            Assert.Equal(SecuritySchemeType.OAuth2, definition.SecurityDefinitions["petstore_auth"].SecuritySchemeType);
            Assert.Equal(SecuritySchemeType.ApiKey, definition.SecurityDefinitions["api_key"].SecuritySchemeType);
        }
    }
}