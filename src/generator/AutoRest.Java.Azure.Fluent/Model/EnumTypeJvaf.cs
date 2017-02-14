using System.Collections.Generic;
using System.Globalization;
using AutoRest.Java.Azure.Model;
using Newtonsoft.Json;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class EnumTypeJvaf : EnumTypeJva
    {
        [JsonIgnore]
        public override IEnumerable<string> Imports
        {
            get
            {
                if (Name != "String")
                {
                    yield return string.Join(".",
                        (CodeModel?.Namespace.ToLowerInvariant()) + (Name.ToString().EndsWith("Inner") ? ".implementation" : ""),
                        Name);
                }
            }
        }

        [JsonIgnore]
        public override string ModelsPackage
        {
            get
            {
                return "";
            }
        }
    }
}
