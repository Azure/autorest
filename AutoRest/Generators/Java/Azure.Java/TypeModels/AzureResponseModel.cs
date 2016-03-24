using Microsoft.Rest.Generator.ClientModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java.Azure
{
    public class AzureResponseModel : ResponseModel
    {
        private Response _response;

        public AzureResponseModel(Response response)
            : base (response)
        {
            this._response = response;
        }

        public AzureResponseModel(ITypeModel body, ITypeModel headers)
            : this(new Response(body, headers))
        {
        }
    }
}
