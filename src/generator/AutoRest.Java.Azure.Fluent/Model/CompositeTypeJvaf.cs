using System;
using System.Globalization;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Java.Azure.Model;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Java.Azure.Fluent.Model
{
    public class CompositeTypeJvaf : CompositeTypeJva
    {
        public CompositeTypeJvaf()
        {
            Name.OnGet += nam => nam.IsNullOrEmpty() || !IsParameterGroupType ? nam : nam + "Inner";
        }

        public CompositeTypeJvaf(string name) : base(name)
        {
            Name.OnGet += nam => nam.IsNullOrEmpty() || !IsParameterGroupType ? nam : nam + "Inner";
        }

        public bool IsParameterGroupType { get; set; } = false;

        public override IEnumerableWithIndex<Property> Properties
        {
            get
            {
                var res = base.Properties;
                res.OfType<PropertyJvaf>().ForEach(p => p.IsInnerModel = IsInnerModel);
                return res;
            }
        }

        public override string Package
        {
            get
            {
                if (this.IsResource)
                {
                    return _azureRuntimePackage;
                }
                else if (Extensions.ContainsKey(ExternalExtension) &&
                    (bool)Extensions[ExternalExtension])
                {
                    return _runtimePackage;
                }
                else if (Name.ToString().EndsWith("Inner", StringComparison.Ordinal))
                {
                    return (CodeModel?.Namespace?.ToLower(CultureInfo.InvariantCulture) ?? "fallbackNamespaceOrWhatTODO") + ".implementation";
                }
                else
                {
                    return (CodeModel?.Namespace?.ToLower(CultureInfo.InvariantCulture) ?? "fallbackNamespaceOrWhatTODO");
                }
            }
        }


        public override string ModelsPackage => IsInnerModel ? ".implementation" : "";

        public bool IsInnerModel
        {
            get
            {
                return true == Name?.ToString()?.EndsWith("Inner", StringComparison.Ordinal);
            }
        }
        public override IEnumerable<string> Imports
        {
            get
            {
                var imports = new List<string>();
                if (Name.Contains('<'))
                {
                    imports.AddRange(ParseGenericType().SelectMany(t => t.Imports));
                }
                else
                {
                    imports.Add(string.Join(".", Package, Name));
                }
                return imports;
            }
        }

        public override IEnumerable<string> ImportList
        {
            get
            {
                List<string> imports = base.ImportList.ToList();
                if (BaseModelType != null && BaseModelType.Name.ToString().EndsWith("Inner", StringComparison.Ordinal) ^ IsInnerModel)
                {
                    imports.AddRange(BaseModelType.ImportSafe());
                }
                return imports.Distinct();
            }
        }
    }
}
