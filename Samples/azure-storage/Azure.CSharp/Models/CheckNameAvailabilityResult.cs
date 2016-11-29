
namespace Petstore.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// The CheckNameAvailability operation response.
    /// </summary>
    public partial class CheckNameAvailabilityResult
    {
        /// <summary>
        /// Initializes a new instance of the CheckNameAvailabilityResult
        /// class.
        /// </summary>
        public CheckNameAvailabilityResult() { }

        /// <summary>
        /// Initializes a new instance of the CheckNameAvailabilityResult
        /// class.
        /// </summary>
        /// <param name="nameAvailable">Gets a boolean value that indicates
        /// whether the name is available for you to use. If true, the name is
        /// available. If false, the name has already been taken or invalid and
        /// cannot be used.</param>
        /// <param name="reason">Gets the reason that a storage account name
        /// could not be used. The Reason element is only returned if
        /// NameAvailable is false. Possible values include:
        /// 'AccountNameInvalid', 'AlreadyExists'</param>
        /// <param name="message">Gets an error message explaining the Reason
        /// value in more detail.</param>
        public CheckNameAvailabilityResult(bool? nameAvailable = default(bool?), Reason? reason = default(Reason?), string message = default(string))
        {
            NameAvailable = nameAvailable;
            Reason = reason;
            Message = message;
        }

        /// <summary>
        /// Gets a boolean value that indicates whether the name is available
        /// for you to use. If true, the name is available. If false, the name
        /// has already been taken or invalid and cannot be used.
        /// </summary>
        [JsonProperty(PropertyName = "nameAvailable")]
        public bool? NameAvailable { get; set; }

        /// <summary>
        /// Gets the reason that a storage account name could not be used. The
        /// Reason element is only returned if NameAvailable is false. Possible
        /// values include: 'AccountNameInvalid', 'AlreadyExists'
        /// </summary>
        [JsonProperty(PropertyName = "reason")]
        public Reason? Reason { get; set; }

        /// <summary>
        /// Gets an error message explaining the Reason value in more detail.
        /// </summary>
        [JsonProperty(PropertyName = "message")]
        public string Message { get; set; }

    }
}

