using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;

namespace AutoRest.Swagger.Validation
{
    public static class SwaggerModelValidationExtensions
    {
        public static ServiceDefinition GetServiceDefinition(this RuleContext context)
        {
            return context?.Root as ServiceDefinition;
        }
    }
}
