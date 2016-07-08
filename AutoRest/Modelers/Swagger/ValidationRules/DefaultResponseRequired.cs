using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Collections.Generic;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class DefaultResponseRequired : TypedRule<IDictionary<string, OperationResponse>>
    {
        public override bool IsValid(IDictionary<string, OperationResponse> entity)
        {
            return entity != null && entity.ContainsKey("default");
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.DefaultResponseRequired;
            }
        }
    }
}
