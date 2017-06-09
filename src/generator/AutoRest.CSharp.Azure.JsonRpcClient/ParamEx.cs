using AutoRest.Core.Model;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.CSharp.Azure.JsonRpcClient
{
    public static class ParamEx
    {
        public static string GetParameterInfoName(this Method m, Parameter p)
            => $"{m.Name}_{p.SerializedName.Value.Replace('-', '_').Replace('$', '_')}_ParamInfo";

        public static string GetInfoName(this Parameter p)
            => p.Method.GetParameterInfoName(p);

        public static string GetConstraint(this KeyValuePair<Constraint, string> p)
        {
            switch(p.Key)
            {
                case Constraint.MinLength:
                    return $"new Microsoft.Rest.ClientRuntime.Test.Azure.Constraints.AzureMinLength({p.Value}),";
                case Constraint.MaxLength:
                    return $"new Microsoft.Rest.ClientRuntime.Test.Azure.Constraints.AzureMaxLength({p.Value}),";
                case Constraint.Pattern:
                    return $"new Microsoft.Rest.ClientRuntime.Test.Azure.Constraints.AzurePattern(@\"{p.Value}\"),";
                default:
                    return string.Empty;
            }
        }

        public static string AsNullableTypeOrDefault(this IModelType v)
            => v == null ? "object" : v.AsNullableType();

        public static string GetExp(this Parameter p)
        {
            if (p.IsConstant)
            {
                return p.DefaultValue;
            }

            var t = p.Method.InputParameterTransformation.FirstOrDefault(x => x.OutputParameter.Name == p.Name);
            if (t == null)
            {
                return p.Name;
            }

            if (t.ParameterMappings.Any(m => m.OutputParameterProperty == null))
            {
                return t.ParameterMappings
                    .Select(m => $"{m.InputParameter.Name}.{m.InputParameterProperty}")
                    .First();
            }

            var properties = t.ParameterMappings
                .Select(m => $"{m.OutputParameterProperty} = {m.InputParameter.Name}");
            return $"new {p.ModelTypeName} {{ {string.Join(", ", properties)} }}";
        }
    }
}
