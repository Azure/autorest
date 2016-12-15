using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Model;
using AutoRest.Java.Model;
using AutoRest.Java.Azure.Model;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class EnumTypeJvaf : EnumTypeJva
    {
        public override IEnumerable<string> Imports
        {
            get
            {
                if (Name != "String") // TODO: refactor this madness
                {
                    yield return string.Join(".",
                        (CodeModel?.Namespace?.ToLower(CultureInfo.InvariantCulture) ?? "fallbackNamespaceOrWhatTODO") + (Name.ToString().EndsWith("Inner") ? ".implementation" : ""),
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
