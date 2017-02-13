using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;

namespace AutoRest.TypeScript.SuperAgent.ModelBinder
{
    public class ModelsModelBinder
    {
        public ModelsModel Bind(CodeModelTs codeModel)
        {
            var models = new ModelsModel
                         {
                            Header = new HeaderModel
                                     {
                                        ApiVersion = codeModel.ApiVersion 
                                     },
                            RequestModels = new List<Model.Model>(),
                            ResponseModels = new List<Model.Model>()
            };

            var parameters = codeModel.Methods.SelectMany(m => m.Parameters).ToArray();
            var propertyTypes = parameters.Select(p => p.ModelType).ToArray();
            var modelTypes = codeModel.ModelTypes.ToArray();
            var nonPropertyTypes = modelTypes.Where(m => !propertyTypes.Contains(m)).ToArray();

            foreach (var method in codeModel.Methods)
            {
                var okResponse = method.Responses[HttpStatusCode.OK];
                var useOptionForTypeName = okResponse.Body.IsPrimaryType() || okResponse.Body.IsSequenceType();
                string name = null;
                
                if(!useOptionForTypeName)
                {
                    var serializedName = method.SerializedName.Value;
                    var parts = serializedName.Split('_');
                    if (parts.Length > 1)
                    {
                        name = parts[0];
                    }
                }

                if (name == null)
                {
                    name = okResponse.Body.Name;
                }

                var modelType = new Model.Model
                {
                    Name = $"{name}Request",
                    Properties = new List<ModelProperty>()
                };

                models.RequestModels.Add(modelType);

                foreach (var parameter in method.Parameters)
                {
                    modelType.Properties.Add(new ModelProperty
                                             {
                                                 Name = parameter.Name,
                                                 IsRequired = parameter.IsRequired,
                                                 TypeName = parameter.ModelType.GetImplementationName()
                                             });
                }
            }

            foreach (var modelType in nonPropertyTypes.Where(m => !m.IsPrimaryType() || !m.IsSequenceType()))
            {
                var model = new Model.Model
                            {
                                Name =  $"{modelType.Name}Response",
                                Properties = new List<ModelProperty>()
                            };

                models.ResponseModels.Add(model);

                foreach (var propertyType in modelType.Properties)
                {
                    model.Properties.Add(new ModelProperty
                                         {
                                             Name = propertyType.Name,
                                             IsRequired = propertyType.IsRequired,
                                             TypeName = propertyType.GetImplementationName()
                                         });
                }
            }

            return models;
        }
    }
}
