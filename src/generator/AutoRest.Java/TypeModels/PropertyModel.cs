using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TypeModels
{
    public class PropertyModel : Property
    {
        protected string _package;

        public PropertyModel(Property property, string package)
            : base()
        {
            this.LoadFrom(property);
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public virtual IEnumerable<string> Imports
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
