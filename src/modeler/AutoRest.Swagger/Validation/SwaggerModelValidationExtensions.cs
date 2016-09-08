using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System;

namespace AutoRest.Swagger.Validation
{
    public static class SwaggerModelValidationExtensions
    {
        public static ServiceDefinition GetServiceDefinition(this RuleContext context)
        {
            return context?.Root as ServiceDefinition;
        }

        /// <summary>
        /// Finds a property by name in the given
        /// </summary>
        /// <param name="schema">The schema to serve as a starting point</param>
        /// <param name="definition">The service definition that contains all definitions</param>
        /// <param name="propertyName">The name of the property to find</param>
        /// <returns>The schema for the found property or null</returns>
        public static Schema FindPropertyInChain(this Schema schema, ServiceDefinition definition, string propertyName)
        {
            Schema propertyDefinition = null;
            var resolver = new SchemaResolver(definition);
            // Try to find the property in this schema or its ancestors
            try
            {
                propertyDefinition = resolver.FindProperty(schema, propertyName);
            }
            catch (InvalidOperationException)
            {
                // There was a problem finding the property (e.g. a circular reference). Return null
            }
            return propertyDefinition;
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
