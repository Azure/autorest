using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.Java.Azure
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
