using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TypeModels
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

        public ITypeModel ParameterVariant
        {
            get
            {
                if (ValueTypeModel.ParameterVariant != ValueTypeModel)
                {
                    return new DictionaryTypeModel(new DictionaryType()
                    {
                        NameFormat = "Map<String, {0}>",
                        ValueType = ValueTypeModel.ParameterVariant
                    });
                }
                return this;
            }
        }

        public ITypeModel ResponseVariant
        {
            get
            {
                if (ValueTypeModel.ResponseVariant != ValueTypeModel)
                {
                    return new DictionaryTypeModel(new DictionaryType()
                    {
                        NameFormat = "Map<String, {0}>",
                        ValueType = ValueTypeModel.ResponseVariant
                    });
                }
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
