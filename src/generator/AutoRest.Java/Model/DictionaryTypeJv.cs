using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using System;

namespace AutoRest.Java.Model
{
    public class DictionaryTypeJv : DictionaryType, IModelTypeJv
    {
        public DictionaryTypeJv()
        {
            Name.OnGet += value => $"Map<String, {ValueType.Name}>";
        }

        public IEnumerable<string> Imports
        {
            get
            {
                List<string> imports = new List<string> { "java.util.Map" };
                return imports.Concat((this.ValueType as IModelTypeJv)?.Imports ?? Enumerable.Empty<string>());
            }
        }
        
        public IModelTypeJv ResponseVariant
        {
            get
            {
                var respvariant = (ValueType as IModelTypeJv).ResponseVariant;
                if (respvariant != ValueType && (respvariant as PrimaryTypeJv)?.Nullable != false)
                {
                    return new DictionaryTypeJv { ValueType = respvariant };
                }
                return this;
            }
        }

        public IModelTypeJv ParameterVariant
        {
            get
            {
                var respvariant = (ValueType as IModelTypeJv).ParameterVariant;
                if (respvariant != ValueType && (respvariant as PrimaryTypeJv)?.Nullable != false)
                {
                    return new DictionaryTypeJv { ValueType = respvariant };
                }
                return this;
            }
        }
        
        public IModelTypeJv NonNullableVariant => this;
    }
}
