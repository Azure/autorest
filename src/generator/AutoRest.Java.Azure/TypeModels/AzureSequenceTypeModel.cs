using AutoRest.Core.ClientModel;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure.TypeModels
{
    public class AzureSequenceTypeModel : SequenceTypeModel
    {
        protected string _azureRuntimePackage = "com.microsoft.azure";

        public AzureSequenceTypeModel()
            : base()
        {
        }

        public AzureSequenceTypeModel(SequenceType javaSequenceType)
            : base(javaSequenceType)
        {
        }

        public string PageImplType { get; set; }
    }
}
