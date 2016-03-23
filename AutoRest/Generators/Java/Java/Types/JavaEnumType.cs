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
    public class JavaEnumType : EnumType, IJavaType
    {
        private string _package;

        public JavaEnumType(EnumType enumType, string package)
            : base()
        {
            this.LoadFrom(enumType);
            this._package = package.ToLower(CultureInfo.InvariantCulture);
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
                yield return string.Join(".", _package, "models", Name);
            }
        }
    }
}
