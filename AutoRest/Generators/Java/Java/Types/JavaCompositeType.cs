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
        private string _package;

        public JavaCompositeType(CompositeType compositeType, string package)
            : base()
        {
            this.LoadFrom(compositeType);
            this._package = package;
        }

        public PrimaryType ParameterType { get; private set; }

        public PrimaryType InternalType { get; private set; }

        public PrimaryType ResponseType { get; private set; }

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
                yield return string.Join(".", _package, Name);
            }
        }
    }
}
