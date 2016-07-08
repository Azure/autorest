using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Generator;

namespace Microsoft.Rest.Modeler.Swagger.Validators
{
    public class DescriptiveDescriptionRequired : TypedRule<string>
    {
        public override bool IsValid(string description)
        {
            return !string.IsNullOrWhiteSpace(description) && !description.Equals("description", System.StringComparison.InvariantCultureIgnoreCase);
        }

        public override ValidationExceptionName Exception
        {
            get
            {
                return ValidationExceptionName.DescriptiveDescriptionRequired;
            }
        }
    }
}
