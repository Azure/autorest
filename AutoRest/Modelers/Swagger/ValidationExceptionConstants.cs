using Microsoft.Rest.Generators.Validation;
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
        public static class Info
        {
            public static readonly IDictionary<ValidationException, string> Messages = new Dictionary<ValidationException, string>
            {
            };
        }

        public static class Warnings
        {
            public static readonly IDictionary<ValidationException, string> Messages = new Dictionary<ValidationException, string>
            {
                { ValidationException.MissingDescription, Resources.MissingDescription },
                { ValidationException.OnlyJSONInRequest, Resources.OnlyJSONInRequests1 },
                { ValidationException.OnlyJSONInResponse, Resources.OnlyJSONInResponses1 }
            };
        }

        public static class Errors
        {
            public static readonly IDictionary<ValidationException, string> Messages = new Dictionary<ValidationException, string>
            {
            };
        }
    }
}
