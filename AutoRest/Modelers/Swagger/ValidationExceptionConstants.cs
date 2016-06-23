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
                { ValidationException.OnlyJSONInResponse, Resources.OnlyJSONInResponses1 },
                { ValidationException.HeaderShouldHaveClientName, Resources.HeaderShouldHaveClientName },
                { ValidationException.InvalidSchemaParameter, Resources.InvalidSchemaParameter },
                { ValidationException.EmptyClientName, Resources.EmptyClientName },
                { ValidationException.ConflictingRef, Resources.ConflictingRef },
            };
        }

        public static class Errors
        {
            public static readonly IDictionary<ValidationException, string> Messages = new Dictionary<ValidationException, string>
            {
                { ValidationException.MissingRequiredProperty, Resources.MissingRequiredProperty },
                { ValidationException.TooManyBodyParameters, Resources.TooManyBodyParameters1 },
                { ValidationException.BodyMustHaveSchema, Resources.BodyMustHaveSchema },
                { ValidationException.BodyWithType, Resources.BodyWithType },
                { ValidationException.NoResponses, Resources.NoResponses },
                { ValidationException.InvalidDefault, Resources.InvalidDefault },
            };
        }
    }
}
