using AutoRest.Core.ClientModel;
using AutoRest.Extensions.Azure;
using System.Text.RegularExpressions;

namespace AutoRest.CSharp.Azure.Fluent
{
    public static class ClientModelExtensions
    {
        public static bool IsResource(this IType type)
        {
            CompositeType compositeType = type as CompositeType;
            return compositeType != null && 
                (type.Name == "Resource" || type.Name == "SubResource" ||
                 type.Name == "Microsoft.Rest.Azure.Resource" || type.Name == "Microsoft.Rest.Azure.SubResource");
        }

        public static bool IsGeneric(this IType type)
        {
            CompositeType compositeType = type as CompositeType;
            if (type != null)
            {
                Regex regex = new Regex("[a-zA-Z][a-zA-Z0-9_]*<[a-zA-Z][a-zA-Z0-9_<>]*>");
                Match match = regex.Match(compositeType.Name);
                return match.Success;
            }
            return false;
        }
    }
}
