// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Swagger.Model;
using ParameterLocation = AutoRest.Swagger.Model.ParameterLocation;

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

            IType parameterType = BuildServiceType(parameterName);
            var parameter = new Parameter
            {
                Name = unwrappedParameter.Name,
                SerializedName = unwrappedParameter.Name,
                Type = parameterType,
                Location = (Core.ClientModel.ParameterLocation)Enum.Parse(typeof(Core.ClientModel.ParameterLocation), unwrappedParameter.In.ToString())
            };
            parameter.IsRequired = parameter.IsRequired || parameter.Location == Core.ClientModel.ParameterLocation.Path;
            PopulateParameter(parameter, unwrappedParameter);

            if (_swaggerParameter.Reference != null)
            {
                var clientProperty = Modeler.ServiceClient.Properties.FirstOrDefault(p => p.SerializedName == unwrappedParameter.Name);
                parameter.ClientProperty = clientProperty;
            }

            return parameter;
        }

        public override IType BuildServiceType(string serviceTypeName)
        {
            // Check if already generated
            if (serviceTypeName != null && Modeler.GeneratedTypes.ContainsKey(serviceTypeName))
            {
                return Modeler.GeneratedTypes[serviceTypeName];
            }

            var swaggerParameter = Modeler.Unwrap(_swaggerParameter);

            // Generic type
            if (swaggerParameter.In != ParameterLocation.Body)
            {
                return swaggerParameter.GetBuilder(Modeler).ParentBuildServiceType(serviceTypeName);
            }

            // Contains a complex type schema
            return swaggerParameter.Schema.GetBuilder(Modeler).BuildServiceType(serviceTypeName);
        }

        public override IType ParentBuildServiceType(string serviceTypeName)
        {
            return base.BuildServiceType(serviceTypeName);
        }
    }
}