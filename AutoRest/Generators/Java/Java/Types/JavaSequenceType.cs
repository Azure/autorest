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

        public JavaSequenceType()
            : base()
        {
        }

        public string ParameterVariant
        {
            get
            {
                return Name;
            }
        }

        public string ResponseVariant
        {
            get
            {
                return Name;
            }
        }

        public string DefaultValue
        {
            get
            {
                return "null";
            }
        }

        public IEnumerable<string> Imports
        {
            get
            {
                List<string> imports = new List<string> { "java.util.List" };
                return imports.Concat(((IJavaType) this.ElementType).Imports);
            }
        }
    }
}
