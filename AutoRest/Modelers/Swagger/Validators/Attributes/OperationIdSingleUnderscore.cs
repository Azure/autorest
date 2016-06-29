using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Linq;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class OperationIdSingleUnderscore : TypeRule<string>
    {
        public override bool IsValid(string obj)
        {
            return obj.Count(c => c == '_') <= 1;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.OnlyOneUnderscoreInOperationId;
            }
        }
    }
}
