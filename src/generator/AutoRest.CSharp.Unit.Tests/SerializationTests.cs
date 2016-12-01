using System.IO;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;
using Xunit;

namespace AutoRest.CSharp.Unit.Tests
{
    public class SerializationTests
    {
        [Fact]
        public void ParseSecurityDefinitionType()
        {
            var swaggerContent = File.ReadAllText(@"Resource\SerializationTests\SerializationTests.json");
            var definition = SwaggerParser.Parse(swaggerContent);
            Assert.Equal(SecuritySchemeType.OAuth2, definition.SecurityDefinitions["petstore_auth"].SecuritySchemeType);
            Assert.Equal(SecuritySchemeType.ApiKey, definition.SecurityDefinitions["api_key"].SecuritySchemeType);
        }
    }
}