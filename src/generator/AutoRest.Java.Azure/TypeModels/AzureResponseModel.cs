using System.Globalization;
using AutoRest.Core.ClientModel;
using AutoRest.Java.Azure.TemplateModels;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure.TypeModels
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

        public override ITypeModel BodyClientType
        {
            get
            {
                var bodySequenceType = base.BodyClientType as AzureSequenceTypeModel;
                if (bodySequenceType != null && (_method.IsPagingOperation || _method.IsPagingNextOperation))
                {
                    return new AzureSequenceTypeModel(new SequenceType { NameFormat = "PagedList<{0}>", ElementType = bodySequenceType.ElementType })
                    {
                        PageImplType = bodySequenceType.PageImplType
                    };
                }
                return base.BodyClientType;
            }
        }

        public override string GenericBodyClientTypeString
        {
            get
            {
                var bodySequenceType = BodyClientType as AzureSequenceTypeModel;
                if (bodySequenceType != null && (_method.IsPagingOperation || _method.IsPagingNextOperation))
                {
                    return string.Format(CultureInfo.InvariantCulture, "PagedList<{0}>", bodySequenceType.ElementType);
                }
                return base.GenericBodyClientTypeString;
            }
        }

        public override string ServiceCallGenericParameterString
        {
            get
            {
                var bodySequenceType = BodyClientType as AzureSequenceTypeModel;
                if (bodySequenceType != null && (_method.IsPagingNextOperation || _method.IsPagingOperation))
                {
                    return string.Format(CultureInfo.InvariantCulture, "List<{0}>", bodySequenceType.ElementType);
                }
                return GenericBodyClientTypeString;
            }
        }

        public override string ServiceResponseGenericParameterString
        {
            get
            {
                var bodySequenceType = BodyClientType as AzureSequenceTypeModel;
                if (bodySequenceType != null && (_method.IsPagingNextOperation || _method.IsPagingOperation))
                {
                    return string.Format(CultureInfo.InvariantCulture, "Page<{0}>", bodySequenceType.ElementType);
                }
                return GenericBodyClientTypeString;
            }
        }

        public override string GenericBodyWireTypeString
        {
            get
            {
                var sequenceType = BodyWireType as AzureSequenceTypeModel;
                if (sequenceType != null && (_method.IsPagingOperation || _method.IsPagingNextOperation || _method.IsPagingNonPollingOperation))
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}>", sequenceType.PageImplType, sequenceType.ElementTypeModel.InstanceType());
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

        public override string ObservableClientResponseTypeString
        {
            get
            {
                if (_method.IsPagingOperation || _method.IsPagingNextOperation)
                {
                    return "ServiceResponse<" + ServiceResponseGenericParameterString + ">";
                }
                return base.ObservableClientResponseTypeString;
            }
        }
    }
}
