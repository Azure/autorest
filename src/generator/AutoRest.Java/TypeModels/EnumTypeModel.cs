using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TypeModels
{
    public class EnumTypeModel : EnumType, ITypeModel
    {
        private string _package;

        public EnumTypeModel(EnumType enumType, string package)
            : base()
        {
            this.LoadFrom(enumType);
            this._package = package.ToLower(CultureInfo.InvariantCulture);
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

        public virtual IEnumerable<string> Imports
        {
            get
            {
                yield return string.Join(".", _package, "models", Name);
            }
        }

        public ITypeModel InstanceType()
        {
            return this;
        }
    }
}
