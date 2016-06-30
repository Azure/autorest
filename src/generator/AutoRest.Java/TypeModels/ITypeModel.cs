using System.Collections.Generic;
using AutoRest.Core.ClientModel;

namespace AutoRest.Java.TypeModels
{
    public interface ITypeModel : IType
    {
        ITypeModel ParameterVariant { get; }

        ITypeModel ResponseVariant { get; }

        IEnumerable<string> Imports { get; }

        ITypeModel InstanceType();

        string DefaultValue(Method method);
    }
}
