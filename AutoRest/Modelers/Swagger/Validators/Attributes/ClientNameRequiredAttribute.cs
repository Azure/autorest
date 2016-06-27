using System;
using Microsoft.Rest.Generators.Validation;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    [AttributeUsage(AttributeTargets.Class, Inherited = true)]
    public class ClientNameRequiredAttribute : RequiredAttribute
    {
        public override bool IsSatisfiedBy(object obj, out object[] formatParams)
        {
            bool valid = true;

            var entity = obj as SwaggerObject;
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

            formatParams = new object[0];
            return valid;
        }

        public override ValidationException Exception
        {
            get
            {
                return ValidationException.ClientNameMustNotBeEmpty;
            }
        }
    }
}
