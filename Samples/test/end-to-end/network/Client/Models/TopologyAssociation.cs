// Code generated by Microsoft (R) AutoRest Code Generator 1.2.2.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace ApplicationGateway.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Resources that have an association with the parent resource.
    /// </summary>
    public partial class TopologyAssociation
    {
        /// <summary>
        /// Initializes a new instance of the TopologyAssociation class.
        /// </summary>
        public TopologyAssociation()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the TopologyAssociation class.
        /// </summary>
        /// <param name="name">The name of the resource that is associated with
        /// the parent resource.</param>
        /// <param name="resourceId">The ID of the resource that is associated
        /// with the parent resource.</param>
        /// <param name="associationType">The association type of the child
        /// resource to the parent resource. Possible values include:
        /// 'Associated', 'Contains'</param>
        public TopologyAssociation(string name = default(string), string resourceId = default(string), string associationType = default(string))
        {
            Name = name;
            ResourceId = resourceId;
            AssociationType = associationType;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the name of the resource that is associated with the
        /// parent resource.
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the ID of the resource that is associated with the
        /// parent resource.
        /// </summary>
        [JsonProperty(PropertyName = "resourceId")]
        public string ResourceId { get; set; }

        /// <summary>
        /// Gets or sets the association type of the child resource to the
        /// parent resource. Possible values include: 'Associated', 'Contains'
        /// </summary>
        [JsonProperty(PropertyName = "associationType")]
        public string AssociationType { get; set; }

    }
}
