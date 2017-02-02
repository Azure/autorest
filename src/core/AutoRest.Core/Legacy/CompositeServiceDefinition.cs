// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using Newtonsoft.Json;

namespace AutoRest.Core.Legacy
{
    /// <summary>
    /// Class that represents a Composite Swagger schema
    /// </summary>
    [Serializable]
    public class CompositeServiceDefinition
    {
        public CompositeServiceDefinition()
        {
            Documents = new List<string>();
        }

        /// <summary>
        /// A list of Swagger documents.
        /// </summary>
        public IList<string> Documents { get; set; }

        public static string[] GetInputFiles(IFileSystem fs, string compositeSwaggerFile)
        {
            var inputBody = fs.ReadAllText(compositeSwaggerFile);
            var parentDir = fs.GetParentDir(compositeSwaggerFile);
            try
            {
                var settings = new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.None,
                    MetadataPropertyHandling = MetadataPropertyHandling.Ignore
                };
                var csd = JsonConvert.DeserializeObject<CompositeServiceDefinition>(inputBody, settings);
                return new[] {compositeSwaggerFile}.Concat(csd.Documents.Select(doc => fs.MakePathRooted(parentDir, doc))).ToArray();
            }
            catch (JsonException ex)
            {
                throw ErrorManager.CreateError($"Error parsing composite swagger. {ex.Message}", ex);
            }
        }
    }
}