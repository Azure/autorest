
namespace Petstore.Models
{
    using Newtonsoft.Json;
    using System.Linq;

    /// <summary>
    /// The URIs that are used to perform a retrieval of a public blob, queue
    /// or table object.
    /// </summary>
    public partial class Endpoints
    {
        /// <summary>
        /// Initializes a new instance of the Endpoints class.
        /// </summary>
        public Endpoints() { }

        /// <summary>
        /// Initializes a new instance of the Endpoints class.
        /// </summary>
        /// <param name="blob">Gets the blob endpoint.</param>
        /// <param name="queue">Gets the queue endpoint.</param>
        /// <param name="table">Gets the table endpoint.</param>
        /// <param name="file">Gets the file endpoint.</param>
        public Endpoints(string blob = default(string), string queue = default(string), string table = default(string), string file = default(string))
        {
            Blob = blob;
            Queue = queue;
            Table = table;
            File = file;
        }

        /// <summary>
        /// Gets the blob endpoint.
        /// </summary>
        [JsonProperty(PropertyName = "blob")]
        public string Blob { get; set; }

        /// <summary>
        /// Gets the queue endpoint.
        /// </summary>
        [JsonProperty(PropertyName = "queue")]
        public string Queue { get; set; }

        /// <summary>
        /// Gets the table endpoint.
        /// </summary>
        [JsonProperty(PropertyName = "table")]
        public string Table { get; set; }

        /// <summary>
        /// Gets the file endpoint.
        /// </summary>
        [JsonProperty(PropertyName = "file")]
        public string File { get; set; }

    }
}

