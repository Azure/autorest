
namespace Petstore.Models
{
    using System;		
    using System.Linq;
    using System.Collections.Generic;		
    using Newtonsoft.Json;		
    using Microsoft.Rest;		
    using Microsoft.Rest.Serialization;		

    public partial class Category
    {
        /// <summary>
        /// Initializes a new instance of the Category class.
        /// </summary>
        public Category() { }

        /// <summary>
        /// Initializes a new instance of the Category class.
        /// </summary>
        public Category(long? id = default(long?), string name = default(string))
        {
            Id = id;
            Name = name;
        }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "id")]
        public long? Id { get; set; }

        /// <summary>
        /// </summary>
        [Newtonsoft.Json.JsonProperty(PropertyName = "name")]
        public string Name { get; set; }

    }
}
