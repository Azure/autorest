using System.Globalization;
using AutoRest.Core.Model;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;

namespace AutoRest.Java.Azure.Model
{
    public class ResponseJva : ResponseJv
    {
        public ResponseJva()
        {
        }

        public ResponseJva(IModelTypeJv body, IModelTypeJv headers)
            : base(body, headers)
        {
        }

        public MethodJva Parent { get; set; }

        public bool IsPagedResponse => Parent.IsPagingNextOperation || Parent.IsPagingOperation;

        public override IModelTypeJv BodyClientType
        {
            get
            {
                var bodySequenceType = base.BodyClientType as SequenceTypeJva;
                if (bodySequenceType != null && IsPagedResponse)
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
                var bodySequenceType = base.BodyClientType as SequenceTypeJva;
                if (bodySequenceType != null && IsPagedResponse)
                {
                    return string.Format(CultureInfo.InvariantCulture, "PagedList<{0}>", bodySequenceType.ElementType.Name);
                }
                return base.GenericBodyClientTypeString;
            }
        }

        public override string ServiceCallGenericParameterString
        {
            get
            {
                var bodySequenceType = base.BodyClientType as SequenceTypeJva;
                if (bodySequenceType != null && IsPagedResponse)
                {
                    return string.Format(CultureInfo.InvariantCulture, "List<{0}>", bodySequenceType.ElementType.Name);
                }
                return GenericBodyClientTypeString;
            }
        }

        public override string ServiceResponseGenericParameterString
        {
            get
            {
                var bodySequenceType = base.BodyClientType as SequenceTypeJva;
                if (bodySequenceType != null && IsPagedResponse)
                {
                    return string.Format(CultureInfo.InvariantCulture, "Page<{0}>", bodySequenceType.ElementType.Name);
                }
                return GenericBodyClientTypeString;
            }
        }

        public override string GenericBodyWireTypeString
        {
            get
            {
                var sequenceType = base.BodyClientType as SequenceTypeJva;
                if (sequenceType != null && (IsPagedResponse || Parent.IsPagingNonPollingOperation))
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}<{1}>", sequenceType.PageImplType, sequenceType.ElementType.Name);
                }
                return base.GenericBodyWireTypeString;
            }
        }

        public override string ClientCallbackTypeString
        {
            get
            {
                if (Body is SequenceType && IsPagedResponse)
                {
                    return BodyClientType.Name;
                }
                return base.ClientCallbackTypeString;
            }
        }

        //public override string GenericHeaderWireTypeString
        //{
        //    get
        //    {
        //        return HeaderWireType.Name;
        //    }
        //}

        public override string ObservableClientResponseTypeString
        {
            get
            {
                if (IsPagedResponse)
                {
                    return "ServiceResponse<" + ServiceResponseGenericParameterString + ">";
                }
                return base.ObservableClientResponseTypeString;
            }
        }
    }
}
