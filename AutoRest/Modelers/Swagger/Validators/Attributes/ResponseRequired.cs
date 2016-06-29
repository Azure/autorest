using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class ResponseRequired : TypeRule<IDictionary<string, OperationResponse>>
    {
        public override bool IsValid(IDictionary<string, OperationResponse> entity)
        {
            bool valid = true;

            if (entity == null || entity.Count == 0)
            {
                valid = false;
            }

            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.AResponseMustBeDefined;
            }
        }
    }
}
