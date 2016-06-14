using Microsoft.Rest.Generator.Azure;
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
        private AzureMethodTemplateModel _method;

        public AzureResponseModel(Response response, AzureMethodTemplateModel method)
            : base (response)
        {
            this._response = response;
            this._method = method;
        }

        public AzureResponseModel(ITypeModel body, ITypeModel headers, AzureMethodTemplateModel method)
            : this(new Response(body, headers), method)
        {
        }

        public override string GenericBodyClientTypeString
        {
            get
            {
                if (BodyClientType is SequenceType && _method.IsPagingNextOperation)
                {
                    var ext = _method.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                    string pageClassName = (string)ext["className"];
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}>", pageClassName, ((SequenceType)BodyClientType).ElementType);
                }
                else if (BodyClientType is SequenceType && _method.IsPagingOperation)
                {
                    return string.Format(CultureInfo.InvariantCulture, "PagedList<{0}>", ((SequenceType)BodyClientType).ElementType);
                }
                return base.GenericBodyClientTypeString;
            }
        }

        public override string GenericBodyWireTypeString
        {
            get
            {
                SequenceTypeModel sequenceType = BodyWireType as SequenceTypeModel;
                if (sequenceType != null && (_method.IsPagingOperation || _method.IsPagingNextOperation || _method.IsPagingNonPollingOperation))
                {
                    var ext = _method.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                    string pageClassName = (string)ext["className"];
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}>", pageClassName, sequenceType.ElementTypeModel.InstanceType());
                }
                return base.GenericBodyWireTypeString;
            }
        }
        public override string ClientCallbackTypeString
        {
            get
            {
                if (Body is SequenceType &&
                    (_method.IsPagingOperation || _method.IsPagingNextOperation))
                {
                    return BodyClientType.InstanceType().Name;
                }
                return base.ClientCallbackTypeString;
            }
        }

        public override string GenericHeaderWireTypeString
        {
            get
            {
                return HeaderWireType.InstanceType().Name;
            }
        }
    }
}
