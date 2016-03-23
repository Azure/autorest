using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java
{
    public class JavaCompositeType : CompositeType, IJavaType
    {
        protected string _package;
        public const string ExternalExtension = "x-ms-external";
        protected string _runtimePackage = "com.microsoft.rest";

        public JavaCompositeType(CompositeType compositeType, string package)
            : this(package)
        {
            this.LoadFrom(compositeType);
        }

        public JavaCompositeType(string package)
            : base()
        {
            this._package = package.ToLower(CultureInfo.InvariantCulture);
        }

        public virtual string Package
        {
            get
            {
                if (Extensions.ContainsKey(ExternalExtension) &&
                    (bool)Extensions[ExternalExtension]) {
                    return _runtimePackage;
                }
                else
                {
                    return string.Join(
                        ".",
                        _package,
                        "models");
                }
            }
        }

        public string ParameterVariant
        {
            get
            {
                return Name;
            }
        }

        public string ResponseVariant
        {
            get
            {
                return Name;
            }
        }

        public string DefaultValue
        {
            get
            {
                return "null";
            }
        }

        public IEnumerable<string> Imports
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

        private IEnumerable<IJavaType> ParseGenericType()
        {
            string name = Name;
            string[] types = Name.Split(new String[] { "<", ">", ",", ", " }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var innerType in types.Where(t => !string.IsNullOrWhiteSpace(t)))
            {
                if (!JavaCodeNamer.PrimaryTypes.Contains(innerType.Trim()))
                {
                    yield return new JavaCompositeType(_package) { Name = innerType.Trim() };
                }
            }
        }
    }
}
