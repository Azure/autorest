using Microsoft.Rest.Generator.ClientModel;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    /// <summary>
    /// Keeps utilities methods for Azure Ruby code generator.
    /// </summary>
    public static class AzureClientModelExtensions
    {
        /// <summary>
        /// Changes namespace to MsRestAzure in case the type is external.
        /// </summary>
        /// <param name="type">The type namespace should be checked for.</param>
        /// <param name="namespaceName">The namespace to check.</param>
        public static void UpdateNamespaceIfRequired(IType type, ref string namespaceName)
        {
            var composite = type as CompositeType;

            if (composite != null && composite.Extensions.ContainsKey(AzureCodeGenerator.ExternalExtension))
            {
                namespaceName = "MsRestAzure";
            }
        }
    }
}
