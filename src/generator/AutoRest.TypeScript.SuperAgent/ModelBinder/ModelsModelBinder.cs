using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.TypeScript.SuperAgent.Model;

namespace AutoRest.TypeScript.SuperAgent.ModelBinder
{
    public class ModelsModelBinder : ModelBinderBaseTs, ITsModelBinder<ModelsModel>
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
                            ResponseModels = new List<Model.Model>(),
                            EnumModels = new List<EnumModel>()
            };

            var modelTypesFromDefinition = codeModel.ModelTypes.ToList();

            var enumsInModels = new List<Tuple<string, IModelType>>();

            Func<IVariable, ModelProperty> getPropertyModel =
                variable =>
                {
                    var propertyType = variable.ModelType;
                    string typeName = null;

                    //if (propertyType.IsEnumType())
                    //{
                    //    var enumType = (EnumTypeTs) propertyType;
                    //    typeName = enumType.GetImplementationName(variable);
                    //    enumsInModels.Add(new Tuple<string, IModelType>(typeName, propertyType));
                    //}

                    return new ModelProperty
                           {
                               Name = variable.Name.ToCamelCase(),
                               IsRequired = variable.IsRequired,
                               TypeName = typeName ?? GetTypeText(propertyType)
                           };
                };

            foreach (var method in codeModel.Methods)
            {
                string requestName = null;
                string responseName = null;
                IModelType modelType = null;

                if (!TryGetResponseName(method, out modelType, out responseName, out requestName))
                {
                    continue;
                }

                var requestModelType = new Model.Model
                {
                    Name = requestName,
                    Properties = new List<ModelProperty>()
                };

                foreach (Parameter parameter in method.Parameters)
                {
                    requestModelType.Properties.Add(getPropertyModel(parameter));
                }

                models.RequestModels.Add(requestModelType);

                if (modelType.IsPrimaryType() || modelType.IsSequenceType() || modelType.IsEnumType())
                {
                    continue;
                }

                var responseModelType = new Model.Model
                {
                    Name = responseName,
                    Properties = new List<ModelProperty>()
                };

                var type = modelTypesFromDefinition.FirstOrDefault(m => m.ClassName == modelType.ClassName);

                if (type == null)
                {
                    continue;
                }

                modelTypesFromDefinition.Remove(type);

                foreach (var property in type.Properties)
                {
                    responseModelType.Properties.Add(getPropertyModel(property));
                }

                models.ResponseModels.Add(responseModelType);
            }

            foreach (var modelType in modelTypesFromDefinition)
            {
                if (modelType.IsPrimaryType() || modelType.IsSequenceType() && modelType.IsEnumType())
                {
                    continue;
                }

                var model = new Model.Model
                            {
                                Name = GetTypeText(modelType),
                                Properties = new List<ModelProperty>()
                            };

                models.ResponseModels.Add(model);

                foreach (var property in modelType.Properties)
                {
                    model.Properties.Add(getPropertyModel(property));
                }
            }

            // disable enum generation for now #ranantawat.

            // foreach (var pair in enumsInModels)
            // {
            //    var enumType = (EnumTypeTs) pair.Item2;
            //    var enumModel = new EnumModel {Name = pair.Item1};

            //    if (enumType.ModelAsString)
            //    {
            //        for (var index = 0; index < enumType.EnumValues.Length; index++)
            //        {
            //            var value = enumType.Children.Cast<EnumValue>().ToArray()[index];
            //            enumModel.Values.Add(value.Name, index);
            //        }
            //    }

            //    models.EnumModels.Add(enumModel);
            // }

            models.EnumModels = models.EnumModels.Distinct().ToList();

            foreach (EnumType enumType in codeModel.EnumTypes.ToArray())
            {
                models.EnumModels.Add(new EnumModel
                {
                    Name = enumType.DeclarationName,
                    Values = new Dictionary<string, object>()
                });
            }

            return models;
        }
    }
}
