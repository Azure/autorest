using System;
using System.Linq;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class EnumTypeTs : EnumType, IImplementationNameAware
    {
        
        public EnumTypeTs()
        {
            Name.OnGet += v => ImplementationName;
        }

        public virtual string ImplementationName => "number";

        // public EnumValue[] EnumValues => Children.Cast<EnumValue>().ToArray();

        // public string GetImplementationName(IVariable variable)
        // {
        //    var className = $"{(variable.Parent as CompositeTypeTs)?.ClassName}";

        //    if (string.IsNullOrWhiteSpace(className))
        //    {
        //        return variable.Name.Value;
        //    }

        //    return $"{className}{variable.Name.Value.Replace(className, "")}";
        // }
    }
}
