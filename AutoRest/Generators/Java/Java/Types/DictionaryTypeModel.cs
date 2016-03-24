using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
{
    public class DictionaryTypeModel : DictionaryType, ITypeModel
    {
        public DictionaryTypeModel(DictionaryType dictionaryType)
            : base()
        {
            this.LoadFrom(dictionaryType);
        }

        public ITypeModel ValueTypeModel
        {
            get
            {
                return (ITypeModel)this.ValueType;
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
                List<string> imports = new List<string> { "java.util.Map" };
                return imports.Concat(((ITypeModel) this.ValueType).Imports);
            }
        }

        public ITypeModel InstanceType()
        {
            return this;
        }
    }
}
