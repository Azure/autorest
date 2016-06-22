using Microsoft.Rest.Modeler.Swagger.Properties;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Microsoft.Rest.Modeler.Swagger
{
    public static class ValidationExceptionConstants
    {
        public enum Exceptions
        {
            MissingDescription = 1,
            OnlyJSONInResponse,
            OnlyJSONInRequest,
        }

        public static class Info
        {
            public static readonly IDictionary<Exceptions, string> Messages = new Dictionary<Exceptions, string>
            {
            };
        }

        public static class Warnings
        {
            public static readonly IDictionary<Exceptions, string> Messages = new Dictionary<Exceptions, string>
            {
                { Exceptions.MissingDescription, Resources.MissingDescription },
                { Exceptions.OnlyJSONInRequest, Resources.OnlyJSONInRequests1 },
                { Exceptions.OnlyJSONInResponse, Resources.OnlyJSONInResponses1 }
            };
        }
        public static class Errors
        {
            public static readonly IDictionary<Exceptions, string> Messages = new Dictionary<Exceptions, string>
            {
            };

            public const int MissingDescription = 1;
        }
    }
}
