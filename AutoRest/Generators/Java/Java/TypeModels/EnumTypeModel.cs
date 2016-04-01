using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java
{
    public class EnumTypeModel : EnumType, ITypeModel
    {
        private string _package;

        public EnumTypeModel(EnumType enumType, string package)
            : base()
        {
            this.LoadFrom(enumType);
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public ITypeModel ParameterVariant
        {
            get
            {
                return this;
            }
        }

        public ITypeModel ResponseVariant
        {
            get
            {
                return this;
            }
        }

        public string DefaultValue(Method method)
        {
            return "null";
        }

        public IEnumerable<string> Imports
        {
            get
            {
                yield return string.Join(".", _package, "models", Name);
            }
        }

        public ITypeModel InstanceType()
        {
            return this;
        }
    }
}
