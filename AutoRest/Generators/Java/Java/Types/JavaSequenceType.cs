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
    public class JavaSequenceType : SequenceType, IJavaType
    {
        public JavaSequenceType(SequenceType sequenceType)
            : base()
        {
            this.LoadFrom(sequenceType);
        }

        public List<string> InterfaceImports { get; private set; }

        public List<string> ImplImports { get; private set; }
    }
}
