using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Model;
using Newtonsoft.Json;
using AutoRest.Core;

namespace AutoRest.Java.Model
{
    public class EnumTypeJv : EnumType, IModelTypeJv
    {
        public EnumTypeJv()
        {
            Name.OnGet += name => string.IsNullOrEmpty(name) || name == "enum" ? "String" : CodeNamer.Instance.GetTypeName(name);
        }

        [JsonIgnore]
        public virtual string ModelsPackage => (this.CodeModel as CodeModelJv).ModelsPackage;

        [JsonIgnore]
        public virtual IEnumerable<string> Imports
        {
            get
            {
                if (Name != "String")
                {
                    yield return string.Join(".",
                        CodeModel?.Namespace.ToLowerInvariant(),
                        "models", Name);
                }
            }
        }

        [JsonIgnore]
        public IModelTypeJv ResponseVariant => this;

        [JsonIgnore]
        public IModelTypeJv ParameterVariant => this;

        [JsonIgnore]
        public IModelTypeJv NonNullableVariant => this;
    }
}
