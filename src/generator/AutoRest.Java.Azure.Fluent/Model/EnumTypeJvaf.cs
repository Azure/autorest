using System.Collections.Generic;
using System.Globalization;
using AutoRest.Java.Azure.Model;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class EnumTypeJvaf : EnumTypeJva
    {
        public override IEnumerable<string> Imports
        {
            get
            {
                if (Name != "String")
                {
                    yield return string.Join(".",
                        (CodeModel?.Namespace.ToLower(CultureInfo.InvariantCulture)) + (Name.ToString().EndsWith("Inner") ? ".implementation" : ""),
                        Name);
                }
            }
        }

        public override string ModelsPackage
        {
            get
            {
                return "";
            }
        }
    }
}
