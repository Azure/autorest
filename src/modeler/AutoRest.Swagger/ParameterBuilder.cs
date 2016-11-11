// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Swagger.Model;
using ParameterLocation = AutoRest.Swagger.Model.ParameterLocation;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swagger
{
    /// <summary>
    /// The builder for building swagger parameters into client model parameters, 
    /// service types or Json serialization types.
    /// </summary>
    public class ParameterBuilder : ObjectBuilder
    {
        private readonly SwaggerParameter _swaggerParameter;

        public ParameterBuilder(SwaggerParameter swaggerParameter, SwaggerModeler modeler)
            : base(swaggerParameter, modeler)
        {
            _swaggerParameter = swaggerParameter;
        }

        public Parameter Build()
        {
            string parameterName = _swaggerParameter.Name;
            SwaggerParameter unwrappedParameter = _swaggerParameter;

            if (_swaggerParameter.Reference != null)
            {
                unwrappedParameter = Modeler.Unwrap(_swaggerParameter);
            }

            if (unwrappedParameter.Schema != null && unwrappedParameter.Schema.Reference != null)
            {
                parameterName = unwrappedParameter.Schema.Reference.StripDefinitionPath();
            }

            if (parameterName == null)
            {
                parameterName = unwrappedParameter.Name;
            }

            IModelType parameterType = BuildServiceType(parameterName);
            var parameter = New<Parameter>(new
            {
                Name = unwrappedParameter.Name,
                SerializedName = unwrappedParameter.Name,
                ModelType = parameterType,
                Location = (Core.Model.ParameterLocation)Enum.Parse(typeof(Core.Model.ParameterLocation), unwrappedParameter.In.ToString())
            });
            parameter.IsRequired = parameter.IsRequired || parameter.Location == Core.Model.ParameterLocation.Path;
            PopulateParameter(parameter, unwrappedParameter);

            if (_swaggerParameter.Reference != null)
            {
                var clientProperty = Modeler.CodeModel.Properties.FirstOrDefault(p => p.SerializedName.Value == unwrappedParameter.Name);
                parameter.ClientProperty = clientProperty;
            }

            return parameter;
        }

        public override IModelType BuildServiceType(string serviceTypeName)
        {
            var swaggerParameter = Modeler.Unwrap(_swaggerParameter);
            
            // create service type
            var serviceType = swaggerParameter.In == ParameterLocation.Body ?
                swaggerParameter.Schema.GetBuilder(Modeler).BuildServiceType(serviceTypeName) :
                swaggerParameter.GetBuilder(Modeler).ParentBuildServiceType(serviceTypeName);
            
            return serviceType;
        }

        public override IModelType ParentBuildServiceType(string serviceTypeName)
        {
            return base.BuildServiceType(serviceTypeName);
        }
    }
}