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
    public class FluentEnumTypeModel : EnumTypeModel
    {
        private string _package;

        public FluentEnumTypeModel(EnumType enumType, string package)
            : base(enumType, package)
        {
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public override IEnumerable<string> Imports
        {
            get
            {
                yield return string.Join(".", _package + (Name.EndsWith("Inner") ? ".implementation" : ""), Name);
            }
        }
    }
}
