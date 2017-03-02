using System.Linq;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class EnumTypeTs : EnumType
    {
        public EnumValue[] EnumValues => Children.Cast<EnumValue>().ToArray();

        public string GetImplementationName(IVariable variable)
        {
            var className = $"{(variable.Parent as CompositeTypeTs)?.ClassName}";
            return $"{className}{variable.Name.Value.Replace(className, "")}";
        }
    }
}
