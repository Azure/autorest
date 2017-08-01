// <auto-generated>
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// </auto-generated>

namespace Searchservice.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// Defines a data deletion detection policy that implements a
    /// soft-deletion strategy. It determines whether an item should be deleted
    /// based on the value of a designated 'soft delete' column.
    /// </summary>
    [Newtonsoft.Json.JsonObject("#Microsoft.Azure.Search.SoftDeleteColumnDeletionDetectionPolicy")]
    public partial class SoftDeleteColumnDeletionDetectionPolicy : DataDeletionDetectionPolicy
    {
        /// <summary>
        /// Initializes a new instance of the
        /// SoftDeleteColumnDeletionDetectionPolicy class.
        /// </summary>
        public SoftDeleteColumnDeletionDetectionPolicy()
        {
          CustomInit();
        }

        /// <summary>
        /// Initializes a new instance of the
        /// SoftDeleteColumnDeletionDetectionPolicy class.
        /// </summary>
        /// <param name="softDeleteColumnName">Gets or sets the name of the
        /// column to use for soft-deletion detection.</param>
        /// <param name="softDeleteMarkerValue">Gets or sets the marker value
        /// that indentifies an item as deleted.</param>
        public SoftDeleteColumnDeletionDetectionPolicy(string softDeleteColumnName = default(string), string softDeleteMarkerValue = default(string))
        {
            SoftDeleteColumnName = softDeleteColumnName;
            SoftDeleteMarkerValue = softDeleteMarkerValue;
            CustomInit();
        }

        /// <summary>
        /// An initialization method that performs custom operations like setting defaults
        /// </summary>
        partial void CustomInit();

        /// <summary>
        /// Gets or sets the name of the column to use for soft-deletion
        /// detection.
        /// </summary>
        [JsonProperty(PropertyName = "softDeleteColumnName")]
        public string SoftDeleteColumnName { get; set; }

        /// <summary>
        /// Gets or sets the marker value that indentifies an item as deleted.
        /// </summary>
        [JsonProperty(PropertyName = "softDeleteMarkerValue")]
        public string SoftDeleteMarkerValue { get; set; }

    }
}
