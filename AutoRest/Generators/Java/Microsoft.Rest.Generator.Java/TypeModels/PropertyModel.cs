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
    public class PropertyModel : Property
    {
        private string _package;

        public PropertyModel(Property property, string package)
            : base()
        {
            this.LoadFrom(property);
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public IEnumerable<string> Imports
        {
            get
            {
                var imports = new List<string>(Type.ImportSafe()
                        .Where(c => !c.StartsWith(
                            string.Join(".", _package, "models"),
                            StringComparison.OrdinalIgnoreCase)));
                if (Type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    imports.AddRange(Type.ImportSafe());
                    imports.AddRange(((ITypeModel) Type).ResponseVariant.ImportSafe());
                }
                return imports;
            }
        }
    }
}
