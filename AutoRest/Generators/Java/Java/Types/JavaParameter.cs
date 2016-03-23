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
    public class JavaParameter : Parameter
    {
        public JavaParameter(Parameter parameter)
            : base()
        {
            this.LoadFrom(parameter);
        }

        //public string TypeString
        //{
        //    get
        //    {
        //        return ((IJavaType)Type).ParameterType;
        //    }
        //}

        public IEnumerable<string> InterfaceImports
        {
            get
            {
                return ((IJavaType) Type).Imports;
            }
        }

        public IEnumerable<string> RetrofitImports
        {
            get
            {
                // type imports
                var imports = new List<string>(((IJavaType)Type).Imports);
                if (Type.IsPrimaryType(KnownPrimaryType.DateTimeRfc1123))
                {
                    imports.Add("com.microsoft.rest.DateTimeRfc1123");
                }
                // parameter location
                imports.Add(LocationImport(this.Location));
                return imports;
            }
        }

        public IEnumerable<string> ImplImports
        {
            get
            {
                var imports = RetrofitImports.ToList();
                if (Location == ParameterLocation.Header)
                {
                    if (this.Type.IsPrimaryType(KnownPrimaryType.ByteArray))
                    {
                        imports.Add("org.apache.commons.codec.binary.Base64");
                    }
                    else if (this.Type is SequenceType)
                    {
                        imports.Add("com.microsoft.rest.serializer.CollectionFormat");
                    }
                }
                if (Type.IsPrimaryType(KnownPrimaryType.Stream) && Location == ParameterLocation.Body)
                {
                    imports.Add("okhttp3.RequestBody");
                    imports.Add("okhttp3.MediaType");
                }
                return imports;
            }
        }

        private string LocationImport(ParameterLocation parameterLocation)
        {
            if (parameterLocation == ParameterLocation.FormData)
            {
                return "retrofit2.http.Part";
            }
            else if (parameterLocation != ParameterLocation.None)
            {
                return "retrofit2.http." + parameterLocation.ToString();
            }
            else
            {
                return null;
            }
        }
    }
}
