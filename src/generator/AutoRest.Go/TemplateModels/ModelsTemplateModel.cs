// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Go;

namespace AutoRest.Go.TemplateModels
{
    public class ModelsTemplateModel : ServiceClient
    {
        public List<EnumTemplateModel> EnumTemplateModels { get; set; }
        public List<ModelTemplateModel> ModelTemplateModels { get; set; }
        public string PackageName { get; set; }
        public Dictionary<IType, string> PagedTypes { get; set; }
        // NextMethodUndefined is used to keep track of those models which are returned by paged methods,
        // but the next method is not defined in the service client, so these models need a preparer.
        public List<IType> NextMethodUndefined { get; set; }
        
        public ModelsTemplateModel(ServiceClient serviceClient, string packageName)
        {
            this.LoadFrom(serviceClient);

            // Collect enumerated types
            // Start with those identified during Swagger analysis (marked by an "x-ms-enum" extension)
            EnumTemplateModels = new List<EnumTemplateModel>();
            foreach (var enumType in EnumTypes)
            {
                if (!enumType.IsNamed())
                {
                    continue;
                }
                EnumTemplateModels.Add(new EnumTemplateModel(enumType));
            }

            // And add any others with a defined name and value list (but not already located)
            serviceClient.ModelTypes
                .ForEach(mt => {
                    mt.Properties.Where(p => p.Type is EnumType && (p.Type as EnumType).IsNamed())
                        .ForEach(p => {
                            if (!EnumTemplateModels.Any(etm => etm.Equals(p.Type)))
                            {
                                EnumTemplateModels.Add(new EnumTemplateModel(p.Type as EnumType));
                            }
                        });
                });
            
            
            EnumTemplateModels.Sort(delegate(EnumTemplateModel x, EnumTemplateModel y)
            {
                return x.Name.CompareTo(y.Name);
            });

            // Ensure all enumerated type values have the simplest possible unique names
            // -- The code assumes that all public type names are unique within the client and that the values
            //    of an enumerated type are unique within that type. To safely promote the enumerated value name
            //    to the top-level, it must not conflict with other existing types. If it does, prepending the
            //    value name with the (assumed to be unique) enumerated type name will make it unique.

            // First, collect all type names (since these cannot change)
            var topLevelNames = new HashSet<string>();
            serviceClient
                .ModelTypes
                .ForEach(mt => topLevelNames.Add(mt.Name));

            // Then, note each enumerated type with one or more conflicting values and collect the values
            // from those enumerated types without conflicts
            EnumTemplateModels
                .ForEach(em => 
                {
                    if (em.Values.Where(v => topLevelNames.Contains(v.Name) || GoCodeNamer.UserDefinedNames.Contains(v.Name)).Count() > 0)
                    {
                        em.HasUniqueNames = false;
                    }
                    else
                    {
                        em.HasUniqueNames = true;
                        topLevelNames.UnionWith(em.Values.Select(ev => ev.Name).ToList());
                    }
                });

            // Collect defined models
            ModelTemplateModels = new List<ModelTemplateModel>();
            ModelTypes
                .ForEach(mt =>
                {
                    ModelTemplateModels.Add(new ModelTemplateModel(mt));
                });
            ModelTemplateModels.Sort(delegate(ModelTemplateModel x, ModelTemplateModel y)
            {
                return x.Name.CompareTo(y.Name);
            });

            // Find all methods that returned paged results
            PagedTypes = new Dictionary<IType, string>();
            NextMethodUndefined = new List<IType>();
            serviceClient.Methods
                .Where(m => m.IsPageable())
                .ForEach(m =>
                {
                    if (!PagedTypes.ContainsKey(m.ReturnValue().Body))
                    {
                        PagedTypes.Add(m.ReturnValue().Body, m.NextLink());
                    }
                    if (!m.NextMethodExists(serviceClient.Methods)) {
                        NextMethodUndefined.Add(m.ReturnValue().Body);
                    }
                });

            // Mark all models returned by one or more methods and note any "next link" fields used with paged data
            ModelTemplateModels
                .Where(mtm =>
                {
                    return Methods.Any(m => m.HasReturnValue() && m.ReturnValue().Body.Equals(mtm));
                })
                .ForEach(mtm =>
                {
                    mtm.IsResponseType = true;
                    if (PagedTypes.ContainsKey(mtm))
                    {
                        mtm.NextLink = GoCodeNamer.PascalCaseWithoutChar(PagedTypes[mtm], '.');
                        if (NextMethodUndefined.Contains(mtm)) {
                            mtm.PreparerNeeded = true;
                        } else {
                            mtm.PreparerNeeded = false;
                        }
                    }
                });

            PackageName = packageName;
        }

        public virtual IEnumerable<string> Imports
        {
            get
            {
                // Create an ordered union of the imports each model requires
                var imports = new HashSet<string>();
                if (ModelTemplateModels != null && ModelTemplateModels.Any(mtm => mtm.IsResponseType))
                {
                    imports.Add("github.com/Azure/go-autorest/autorest");
                } 
                ModelTypes
                    .ForEach(mt =>
                    {
                        (mt as CompositeType).AddImports(imports);
                        if (NextMethodUndefined.Count > 0)
                        {
                            imports.UnionWith(GoCodeNamer.PageableImports);
                        }
                    });
                return imports.OrderBy(i => i);
            }
        }
    }
}
