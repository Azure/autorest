using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public static class ModelTypeExtensions
    {
        public static string GetImplementationName(this Property property)
        {
            return property.ModelType.GetImplementationName();
        }

        public static string GetImplementationName(this Parameter parameter)
        {
            return parameter.ModelType.GetImplementationName();
        }

        public static string GetImplementationName(this IModelType modelType)
        {
            var nameAware = modelType as IImplementationNameAware;
            var typeName = nameAware == null ? modelType.Name.Value : nameAware.ImplementationName;

            return typeName;
        }
    }
}
