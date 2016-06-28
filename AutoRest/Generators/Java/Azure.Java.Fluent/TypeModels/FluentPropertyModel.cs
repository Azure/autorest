using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java.Azure.Fluent
{
    public class FluentPropertyModel : PropertyModel
    {
        private bool isInnerModel;

        public FluentPropertyModel(Property property, string package, bool isInnerModel)
            : base(property, package)
        {
            this.isInnerModel = isInnerModel;
        }

        public override IEnumerable<string> Imports
        {
            get
            {
                var imports = new List<string>(Type.ImportSafe()
                        .Where(c => !c.StartsWith(_package)
                            || c.EndsWith("Inner") ^ isInnerModel));
                if (Type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    imports.AddRange(Type.ImportSafe());
                    imports.AddRange(((ITypeModel)Type).ResponseVariant.ImportSafe());
                }
                return imports;
            }
        }
    }
}
