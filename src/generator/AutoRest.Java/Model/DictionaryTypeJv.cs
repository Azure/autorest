using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using System;

namespace AutoRest.Java.Model
{
    public class DictionaryTypeJv : DictionaryType, IModelTypeJv
    {
        public IEnumerable<string> Imports
        {
            get
            {
                List<string> imports = new List<string> { "java.util.Map" };
                return imports.Concat((this.ValueType as IModelTypeJv)?.Imports ?? Enumerable.Empty<string>());
            }
        }

        public IModelTypeJv ResponseVariant => this;
        public IModelTypeJv NonNullableVariant => this;
    }
}
