// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    public class RequirementsTemplateModel : ServiceClient
    {
        public RequirementsTemplateModel(ServiceClient serviceClient)
        {
            this.LoadFrom(serviceClient);
        }

        public string GetClientRequiredFile()
        {
            return this.GetRequiredFormat(RubyCodeNamingFramework.UnderscoreCase(this.Name) + ".rb");
        }

        public string GetOperationsRequiredFiles()
        {
            var sb = new IndentedStringBuilder();
            this.MethodGroups.ForEach(method => sb.AppendLine("{0}", 
                this.GetRequiredFormat(RubyCodeNamingFramework.UnderscoreCase(method) + ".rb")));
            return sb.ToString();
        }

        public string GetModelsRequiredFiles()
        {
            var sb = new IndentedStringBuilder();
            this.GetOrderedModels().ForEach(model => sb.AppendLine("{0}",
                this.GetRequiredFormat("models/" + RubyCodeNamingFramework.UnderscoreCase(model.Name) + ".rb")));
            return sb.ToString();
        }

        public IEnumerable<CompositeType> GetOrderedModels()
        {
            List<CompositeType> resultModels = new List<CompositeType>();
            List<CompositeType> models = new List<CompositeType>();
            models.AddRange(this.ModelTypes);

            int count = models.Count;
            while (models.Any())
            {
                var types = models.Where(t => !this.GetDependencyTypes(t).Any(dt => models.Contains(dt))).ToArray();
                resultModels.AddRange(types);
                models = models.Except(types).ToList();

                if (count == models.Count)
                {
                    resultModels.AddRange(models);
                    return resultModels;
                }
            }

            return resultModels;
        }

        private IEnumerable<CompositeType> GetDependencyTypes(CompositeType type)
        {
            List<CompositeType> result = new List<CompositeType>()
                                            {
                                                type.BaseModelType
                                            };
            return result;
        }

        private string GetRequiredFormat(string file)
        {
            return string.Format("require_relative '{0}'", file);
        }
    }
}