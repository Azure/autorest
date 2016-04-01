using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
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
