using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Azure;

namespace Microsoft.Rest.Generator.Java.Azure
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
