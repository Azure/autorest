using System.Globalization;
using AutoRest.Core.Model;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;

namespace AutoRest.Java.Azure.Model
{
    public class ResponseJva : ResponseJv
    {
        private MethodJva _method;

        public override IModelTypeJv BodyClientType
        {
            get
            {
                var bodySequenceType = base.BodyClientType as SequenceTypeJva;
                if (bodySequenceType != null && (_method.IsPagingOperation || _method.IsPagingNextOperation))
                {
                    var result = new SequenceTypeJva
                    {
                        ElementType = bodySequenceType.ElementType,
                        PageImplType = bodySequenceType.PageImplType
                    };
                    result.Name.OnGet += name => $"PagedList<{name}>";
                }
                return base.BodyClientType;
            }
        }

        public override string GenericBodyClientTypeString
        {
            get
            {
                var bodySequenceType = BodyClientType as SequenceTypeJva;
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
                var bodySequenceType = BodyClientType as SequenceTypeJva;
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
                var bodySequenceType = BodyClientType as SequenceTypeJva;
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
                var sequenceType = BodyWireType as SequenceTypeJva;
                if (sequenceType != null && (_method.IsPagingOperation || _method.IsPagingNextOperation || _method.IsPagingNonPollingOperation))
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}>", sequenceType.PageImplType, sequenceType.ElementType);
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
                    return BodyClientType.Name;
                }
                return base.ClientCallbackTypeString;
            }
        }

        public override string GenericHeaderWireTypeString
        {
            get
            {
                return HeaderWireType.Name;
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
