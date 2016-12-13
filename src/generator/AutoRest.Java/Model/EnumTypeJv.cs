using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using System;

namespace AutoRest.Java.Model
{
    public class EnumTypeJv : EnumType, IModelTypeJv
    {
        public string ModelsPackage => (this.CodeModel as CodeModelJv).ModelsPackage;
        
        public virtual IEnumerable<string> Imports
        {
            get
            {
                yield return string.Join(".",
                    // _package, // TODO 
                    "models", Name);
            }
        }

        public IModelTypeJv ResponseVariant => this;

        public IModelTypeJv NonNullableVariant => this;
    }
}
