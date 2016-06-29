using System;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class ClientNameRequired : TypeRule<SwaggerObject>
    {
        public override bool IsValid(SwaggerObject entity)
        {
            bool valid = true;

            object clientName = null;
            if (entity != null && entity.Extensions != null && entity.Extensions.TryGetValue("x-ms-client-name", out clientName))
            {
                var ext = clientName as Newtonsoft.Json.Linq.JContainer;
                if (ext != null && (ext["name"] == null || string.IsNullOrEmpty(ext["name"].ToString())))
                {
                    valid = false;
                }
                else if (string.IsNullOrEmpty(clientName as string))
                {
                    valid = false;
                }
            }

            return valid;
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.ClientNameMustNotBeEmpty;
            }
        }
    }
}
