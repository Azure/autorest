// Code generated by Microsoft (R) AutoRest Code Generator 1.2.1.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Swagger.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    public partial class ErrorDetails
    {
        /// <summary>
        /// Initializes a new instance of the ErrorDetails class.
        /// </summary>
        public ErrorDetails()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the ErrorDetails class.
        /// </summary>
        public ErrorDetails(string code = default(string), string target = default(string), string message = default(string))
        {
            Code = code;
            Target = target;
            Message = message;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "code")]
        public string Code { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "target")]
        public string Target { get; set; }

        /// <summary>
        /// </summary>
        [JsonProperty(PropertyName = "message")]
        public string Message { get; set; }

    }
}
