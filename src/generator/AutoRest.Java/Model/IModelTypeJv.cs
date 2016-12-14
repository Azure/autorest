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

    public static class IModelTypeExtensions
    {
        public static IModelType ServiceResponseVariant(this IModelType original, bool wantNullable = false)
        {
            if (wantNullable)
            {
                return original; // the original is always nullable
            }
            return (original as IModelTypeJv)?.ResponseVariant?.NonNullableVariant ?? original;
        }
    }
}
