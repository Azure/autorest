using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;

namespace AutoRest.Java.Model
{
    public class EnumTypeJv : EnumType
    {
        private string _package;

        public EnumTypeJv(EnumType enumType, string package)
            : base()
        {
            this.LoadFrom(enumType);
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public string ModelsPackage => (this.CodeModel as CodeModelJv).ModelsPackage;
        
        public virtual IEnumerable<string> Imports
        {
            get
            {
                yield return string.Join(".", _package, "models", Name);
            }
        }
    }
}
