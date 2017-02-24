using System.Collections.Generic;
using System.Linq;
using System.Net;
using AutoRest.Core.Model;
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

            var modelTypesFromDefinition = codeModel.ModelTypes.ToList();

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
                    responseName = $"I{okResponse.Body.Name}";
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
                        TypeName = GetTypeText(parameter.ModelType)
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

                var type = modelTypesFromDefinition.FirstOrDefault(m => m.ClassName == okResponse.Body.ClassName);

                if (type == null)
                {
                    continue;
                }

                modelTypesFromDefinition.Remove(type);

                foreach (var property in type.Properties)
                {
                    responseModelType.Properties.Add(new ModelProperty
                                             {
                                                 Name = property.Name.ToCamelCase(),
                                                 IsRequired = property.IsRequired,
                                                 TypeName = GetTypeText(property.ModelType)
                                             });
                }

                models.ResponseModels.Add(responseModelType);
            }

            foreach (var modelType in modelTypesFromDefinition.Where(m => !m.IsPrimaryType() || !m.IsSequenceType()))
            {
                var model = new Model.Model
                            {
                                Name = GetTypeText(modelType),
                                Properties = new List<ModelProperty>()
                            };

                models.ResponseModels.Add(model);

                foreach (var property in modelType.Properties)
                {
                    var propertyType = property.ModelType;

                    model.Properties.Add(new ModelProperty
                                         {
                                             Name = property.Name.ToCamelCase(),
                                             IsRequired = property.IsRequired,
                                             TypeName = GetTypeText(propertyType)
                    });
                }
            }

            return models;
        }

        protected string GetTypeText(IModelType modelType)
        {
            var seqType = modelType as SequenceTypeTs;

            string name = "";

            if (seqType == null)
            {
                name = modelType.GetImplementationName();
                return modelType.IsPrimaryType() ? name : $"I{name}";
            }

            var elementType = seqType.ElementType;
            name = elementType.GetImplementationName();

            return SequenceTypeTs.CreateSeqTypeText(elementType.IsPrimaryType() ? name : $"I{name}");
        }
    }
}
