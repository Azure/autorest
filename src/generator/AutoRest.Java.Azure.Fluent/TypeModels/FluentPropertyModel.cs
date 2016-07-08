using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure.Fluent.TypeModels
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
                        .Where(c => !c.StartsWith(_package, StringComparison.Ordinal)
                            || c.EndsWith("Inner", StringComparison.Ordinal) ^ isInnerModel));
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
