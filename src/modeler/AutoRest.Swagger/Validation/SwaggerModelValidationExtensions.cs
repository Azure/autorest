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

        /// <summary>
        /// Traverses <paramref name="context"/> to find the first ancestor of type <paramref name="T"/>
        /// </summary>
        /// <typeparam name="T">The type of value to find</typeparam>
        /// <param name="context"></param>
        /// <returns>The first ancestor of type T or null</returns>
        public static T GetFirstAncestor<T>(this RuleContext context) where T : class
        {
            var current = context;
            T value = context.Value as T;
            while (current != null && value == null)
            {
                value = current.Value as T;
                current = current.Parent;
            }
            return value;
        }
    }
}
