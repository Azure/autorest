using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TypeModels
{
    public class CompositeTypeModel : CompositeType, ITypeModel
    {
        protected string _package;
        public const string ExternalExtension = "x-ms-external";
        protected string _runtimePackage = "com.microsoft.rest";

        public CompositeTypeModel(CompositeType compositeType, string package)
            : this(package)
        {
            this.LoadFrom(compositeType);
        }

        public CompositeTypeModel(string package)
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

        public ITypeModel ParameterVariant
        {
            get
            {
                return this;
            }
        }

        public ITypeModel ResponseVariant
        {
            get
            {
                return this;
            }
        }

        public string DefaultValue(Method method)
        {
            return "null";
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

        public ITypeModel InstanceType()
        {
            return this;
        }

        private IEnumerable<ITypeModel> ParseGenericType()
        {
            string name = Name;
            string[] types = Name.Split(new String[] { "<", ">", ",", ", " }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var innerType in types.Where(t => !string.IsNullOrWhiteSpace(t)))
            {
                if (!JavaCodeNamer.PrimaryTypes.Contains(innerType.Trim()))
                {
                    yield return new CompositeTypeModel(_package) { Name = innerType.Trim() };
                }
            }
        }
    }
}
