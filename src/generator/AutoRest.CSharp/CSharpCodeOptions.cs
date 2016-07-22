using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.CSharp.TemplateModels;
using Newtonsoft.Json;

namespace AutoRest.CSharp
{
    public class CSharpCodeOptions
    {
        public CSharpCodeOptions()
        {
            ModelOptions = new ModelTemplateOptions();
        }

        [JsonProperty("modelOptions")]
        public ModelTemplateOptions ModelOptions { get; set; }

        /// <summary>
        /// Indicates whether the client ctor needs to be generated with internal protection level.
        /// </summary>
        [JsonProperty("internalConstructors")]
        public bool InternalConstructors { get; set; }

        /// <summary>
        /// Specifies mode for generating sync wrappers.
        /// </summary>
        [JsonProperty("syncMethods")]
        public SyncMethodsGenerationMode SyncMethods { get; set; }
    }
}
