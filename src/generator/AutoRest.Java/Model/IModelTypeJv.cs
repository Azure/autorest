using AutoRest.Core.Model;
using System.Collections.Generic;

namespace AutoRest.Java.Model
{
    public interface IModelTypeJv : IModelType
    {
        IEnumerable<string> Imports { get; }
        
        IModelTypeJv ResponseVariant { get; }
        IModelTypeJv ParameterVariant { get; }

        IModelTypeJv NonNullableVariant { get; }
    }
}
