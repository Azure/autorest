using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Model;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Java.Azure.Model
{
    public class CompositeTypeJva : CompositeTypeJv
    {
        public CompositeTypeJva()
        {
        }

        public CompositeTypeJva(string name) : base(name)
        {
        }

        protected string _azureRuntimePackage = "com.microsoft.azure";

        public override string Package => IsResource
            ? _azureRuntimePackage
            : base.Package.Replace(".models", "");

        public bool IsResource =>
            (Name == "Resource" || Name == "SubResource") &&
            Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) && (bool)Extensions[AzureExtensions.AzureResourceExtension];
        
        public override string ExceptionTypeDefinitionName
        {
            get
            {
                if (this.Extensions.ContainsKey(SwaggerExtensions.NameOverrideExtension))
                {
                    var ext = this.Extensions[SwaggerExtensions.NameOverrideExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (ext != null && ext["name"] != null)
                    {
                        return ext["name"].ToString();
                    }
                }
                return this.Name + "Exception";
            }
        }

        public override IEnumerable<string> ImportList
        {
            get
            {
                var imports = base.ImportList.ToList();
                foreach (var property in this.Properties)
                {
                    if (property.ModelType.IsResource())
                    {
                        imports.Add("com.microsoft.azure." + property.ModelType.Name);
                    }
                }
                if (this.BaseModelType != null && (this.BaseModelType.Name == "Resource" || this.BaseModelType.Name == "SubResource"))
                {
                    imports.Add("com.microsoft.azure." + BaseModelType.Name);
                }
                return imports.Distinct();
            }
        }
    }
}
