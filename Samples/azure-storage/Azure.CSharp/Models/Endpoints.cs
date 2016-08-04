
namespace Petstore.Models
{
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
        public Endpoints(System.String blob = default(System.String), System.String queue = default(System.String), System.String table = default(System.String), System.String file = default(System.String))
        {
            Blob = blob;
            Queue = queue;
            Table = table;
            File = file;
        }

        /// <summary>
        /// Gets the blob endpoint.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "blob")]
        public System.String Blob { get; set; }

        /// <summary>
        /// Gets the queue endpoint.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "queue")]
        public System.String Queue { get; set; }

        /// <summary>
        /// Gets the table endpoint.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "table")]
        public System.String Table { get; set; }

        /// <summary>
        /// Gets the file endpoint.
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "file")]
        public System.String File { get; set; }

    }
}
