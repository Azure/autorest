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
        string DefaultValue { get; }

        string ParameterVariant { get; }

        string ResponseVariant { get; }

        IEnumerable<string> Imports { get; }

        ITypeModel InstanceType();
    }
}
