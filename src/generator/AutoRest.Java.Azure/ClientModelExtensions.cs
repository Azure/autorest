using AutoRest.Core.ClientModel;
using AutoRest.Extensions.Azure;

namespace AutoRest.Java.Azure
{
    public static class ClientModelExtensions
    {
        public static bool IsResource(this IType type)
        {
            CompositeType compositeType = type as CompositeType;
            return compositeType != null && (type.Name == "Resource" || type.Name == "SubResource") &&
                compositeType.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                    (bool)compositeType.Extensions[AzureExtensions.AzureResourceExtension];
        }
    }
}
