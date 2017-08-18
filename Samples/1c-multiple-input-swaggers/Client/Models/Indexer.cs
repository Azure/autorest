// Code generated by Microsoft (R) AutoRest Code Generator 1.2.2.0
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.

namespace Searchservice.Models
{
    using Microsoft.Rest;
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Represents an Azure Search indexer.
    /// <see href="https://msdn.microsoft.com/library/azure/dn946891.aspx" />
    /// </summary>
    public partial class Indexer
    {
        /// <summary>
        /// Initializes a new instance of the Indexer class.
        /// </summary>
        public Indexer()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the Indexer class.
        /// </summary>
        /// <param name="name">Gets or sets the name of the indexer.</param>
        /// <param name="dataSourceName">Gets or sets the name of the
        /// datasource from which this indexer reads data.</param>
        /// <param name="targetIndexName">Gets or sets the name of the index to
        /// which this indexer writes data.</param>
        /// <param name="description">Gets or sets the description of the
        /// indexer.</param>
        /// <param name="schedule">Gets or sets the schedule for this
        /// indexer.</param>
        /// <param name="parameters">Gets or sets parameters for indexer
        /// execution.</param>
        public Indexer(string name, string dataSourceName, string targetIndexName, string description = default(string), IndexingSchedule schedule = default(IndexingSchedule), IndexingParameters parameters = default(IndexingParameters))
        {
            Name = name;
            Description = description;
            DataSourceName = dataSourceName;
            TargetIndexName = targetIndexName;
            Schedule = schedule;
            Parameters = parameters;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the name of the indexer.
        /// </summary>
        [JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the description of the indexer.
        /// </summary>
        [JsonProperty(PropertyName = "description")]
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets the name of the datasource from which this indexer
        /// reads data.
        /// </summary>
        [JsonProperty(PropertyName = "dataSourceName")]
        public string DataSourceName { get; set; }

        /// <summary>
        /// Gets or sets the name of the index to which this indexer writes
        /// data.
        /// </summary>
        [JsonProperty(PropertyName = "targetIndexName")]
        public string TargetIndexName { get; set; }

        /// <summary>
        /// Gets or sets the schedule for this indexer.
        /// </summary>
        [JsonProperty(PropertyName = "schedule")]
        public IndexingSchedule Schedule { get; set; }

        /// <summary>
        /// Gets or sets parameters for indexer execution.
        /// </summary>
        [JsonProperty(PropertyName = "parameters")]
        public IndexingParameters Parameters { get; set; }

        /// <summary>
        /// Validate the object.
        /// </summary>
        /// <exception cref="ValidationException">
        /// Thrown if validation fails
        /// </exception>
        public virtual void Validate()
        {
            if (Name == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "Name");
            }
            if (DataSourceName == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "DataSourceName");
            }
            if (TargetIndexName == null)
            {
                throw new ValidationException(ValidationRules.CannotBeNull, "TargetIndexName");
            }
            if (Schedule != null)
            {
                Schedule.Validate();
            }
        }
    }
}
