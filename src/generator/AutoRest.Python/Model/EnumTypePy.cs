using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Python.Model
{
    public class EnumTypePy : EnumType, IExtendedModelTypePy
    {
        public string TypeDocumentation => Parent == null || Name.IsNullOrEmpty() ? "str" : $"str or :class:`{Name} <{((CodeModelPy)CodeModel)?.modelNamespace}.models.{Name}>`";
        //ModelAsString ? 
        //"str" : 
        public string ReturnTypeDocumentation => ModelAsString || Parent == null ? "str" :  $":class:`{Name} <{((CodeModelPy)CodeModel)?.modelNamespace}.models.{Name}>`";

    }
}
