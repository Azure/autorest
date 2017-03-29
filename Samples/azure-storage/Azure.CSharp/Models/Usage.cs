
namespace Petstore.Models
{
    using System.Linq;

    /// <summary>
    /// Describes Storage Resource Usage.
    /// </summary>
    public partial class Usage
    {
        /// <summary>
        /// Initializes a new instance of the Usage class.
        /// </summary>
        public Usage()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Usage class.
        /// </summary>
        /// <param name="unit">Gets the unit of measurement. Possible values
        /// include: 'Count', 'Bytes', 'Seconds', 'Percent', 'CountsPerSecond',
        /// 'BytesPerSecond'</param>
        /// <param name="currentValue">Gets the current count of the allocated
        /// resources in the subscription.</param>
        /// <param name="limit">Gets the maximum count of the resources that
        /// can be allocated in the subscription.</param>
        /// <param name="name">Gets the name of the type of usage.</param>
        public Usage(UsageUnit unit, int currentValue, int limit, UsageName name)
        {
            this.Unit = unit;
            this.CurrentValue = currentValue;
            this.Limit = limit;
            this.Name = name;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets the unit of measurement. Possible values include: 'Count',
        /// 'Bytes', 'Seconds', 'Percent', 'CountsPerSecond', 'BytesPerSecond'
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "unit")]
        public UsageUnit Unit { get; set; }

        /// <summary>
        /// Gets the current count of the allocated resources in the
        /// subscription.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "currentValue")]
        public int CurrentValue { get; set; }

        /// <summary>
        /// Gets the maximum count of the resources that can be allocated in
        /// the subscription.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "limit")]
        public int Limit { get; set; }

        /// <summary>
        /// Gets the name of the type of usage.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "name")]
        public UsageName Name { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="Microsoft.Rest.ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (this.Name == null)
            {
                throw new Microsoft.Rest.ValidationException(Microsoft.Rest.ValidationRules.CannotBeNull, "Name");
            }
        }
    }
}
