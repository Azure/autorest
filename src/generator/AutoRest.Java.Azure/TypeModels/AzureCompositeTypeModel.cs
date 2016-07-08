using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure.TypeModels
{
    public class AzureCompositeTypeModel : CompositeTypeModel
    {
        protected string _azureRuntimePackage = "com.microsoft.azure";

        public AzureCompositeTypeModel(CompositeTypeModel javaCompositeType)
            : this(javaCompositeType.Package.Replace(".models", ""))
        {
            this.LoadFrom(javaCompositeType);
        }

        public AzureCompositeTypeModel(CompositeType compositeType, string package)
            : this(package)
        {
            this.LoadFrom(compositeType);
        }

        public AzureCompositeTypeModel(string package)
            : base(package)
        {
            this._package = package;
        }

        public override string Package
        {
	        get 
	        { 
		        if (this.IsResource) {
                    return _azureRuntimePackage;
                }
                else
                {
                    return base.Package;
                }
	        }
        }

        public bool IsResource
        {
            get
            {
                return (Name == "Resource" || Name == "SubResource") &&
                    Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                        (bool)Extensions[AzureExtensions.AzureResourceExtension];
            }
        }
    }
}
