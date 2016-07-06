using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.ClientModel;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure.Fluent.TypeModels
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
