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
    public class JavaCompositeType : CompositeType, IJavaType
    {
        public JavaCompositeType(CompositeType compositeType)
            : base()
        {
            this.LoadFrom(compositeType);
        }

        public PrimaryType ParameterType { get; private set; }

        public PrimaryType InternalType { get; private set; }

        public PrimaryType ResponseType { get; private set; }

        public List<string> InterfaceImports { get; private set; }

        public List<string> ImplImports { get; private set; }
    }
}
