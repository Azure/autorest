using System.Collections.Generic;
using System.Linq;
using System.Net;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;

namespace AutoRest.TypeScript.SuperAgent.ModelBinder
{
    public class ModelsModelBinder : ITsModelBinder<ModelsModel>
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
            var modelTypes = codeModel.ModelTypes.ToList();

            foreach (var method in codeModel.Methods)
            {
                var okResponse = method.Responses[HttpStatusCode.OK];

                var doNotWrap = okResponse.Body.IsPrimaryType() || okResponse.Body.IsSequenceType();

                string requestName = null;
                string responseName = null;

                if (doNotWrap)
                {
                    var serializedName = method.SerializedName.Value;
                    var parts = serializedName.Split('_');
                    if (parts.Length > 1)
                    {
                        requestName = parts[0];
                    }

                    responseName = okResponse.Body.GetImplementationName();
                }
                else
                {
                    responseName = okResponse.Body.Name;
                }

                if (requestName == null)
                {
                    requestName = okResponse.Body.GetImplementationName();
                }

                var requestModelType = new Model.Model
                {
                    Name = $"{requestName}Request",
                    Properties = new List<ModelProperty>()
                };

                foreach (var parameter in method.Parameters)
                {
                    requestModelType.Properties.Add(new ModelProperty
                    {
                        Name = parameter.Name.ToCamelCase(),
                        IsRequired = parameter.IsRequired,
                        TypeName = parameter.ModelType.GetImplementationName()
                    });
                }

                models.RequestModels.Add(requestModelType);

                if (okResponse.Body.IsPrimaryType() || okResponse.Body.IsSequenceType())
                {
                    continue;
                }

                var responseModelType = new Model.Model
                {
                    Name = responseName,
                    Properties = new List<ModelProperty>()
                };

                var type = modelTypes.First(m => m.ClassName == okResponse.Body.ClassName);
                modelTypes.Remove(type);

                foreach (var property in type.Properties)
                {
                    responseModelType.Properties.Add(new ModelProperty
                                             {
                                                 Name = property.Name.ToCamelCase(),
                                                 IsRequired = property.IsRequired,
                                                 TypeName = property.ModelType.GetImplementationName()
                                             });
                }

                models.ResponseModels.Add(responseModelType);
            }

            foreach (var modelType in modelTypes.Where(m => !m.IsPrimaryType() || !m.IsSequenceType()))
            {
                var model = new Model.Model
                            {
                                Name =  $"{modelType.Name}",
                                Properties = new List<ModelProperty>()
                            };

                models.ResponseModels.Add(model);

                foreach (var propertyType in modelType.Properties)
                {
                    model.Properties.Add(new ModelProperty
                                         {
                                             Name = propertyType.Name.ToCamelCase(),
                                             IsRequired = propertyType.IsRequired,
                                             TypeName = propertyType.GetImplementationName()
                                         });
                }
            }

            return models;
        }
    }
}
