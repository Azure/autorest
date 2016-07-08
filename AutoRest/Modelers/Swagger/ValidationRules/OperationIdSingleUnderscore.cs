using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class OperationIdSingleUnderscore : TypedRule<string>
    {
        public override bool IsValid(string entity)
        {
            return entity != null && entity.Count(c => c == '_') <= 1;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.OnlyOneUnderscoreInOperationId;
            }
        }
    }
}
