using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using Newtonsoft.Json.Linq;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Extensions
{
    public static class ParameterGroupExtensionHelper
    {
        private class ParameterGroup
        {
            public string Name { get; }

            public Dictionary<Property, Parameter> ParameterMapping { get; }

            public ParameterGroup(string name, Dictionary<Property, Parameter> parameterMapping)
            {
                this.Name = name;
                this.ParameterMapping = parameterMapping;
            }
        }

        private static Property CreateParameterGroupProperty(Parameter parameter)
        {
            Property groupProperty = New<Property>(new
            {
                IsReadOnly = false, //Since these properties are used as parameters they are never read only
                Name = parameter.Name,
                IsRequired = parameter.IsRequired,
                DefaultValue = parameter.DefaultValue,
                //Constraints = parameter.Constraints, Omit these since we don't want to perform parameter validation
                Documentation = parameter.Documentation,
                ModelType = parameter.ModelType,
                SerializedName = default(string) //Parameter is never serialized directly
            });

            // Copy over extensions
            foreach (var key in parameter.Extensions.Keys)
            {
                groupProperty.Extensions[key] = parameter.Extensions[key];
            }

            return groupProperty;
        }

        private static ParameterGroup BuildParameterGroup(string parameterGroupName, Method method)
        {
            Dictionary<Property, Parameter> parameterMapping = method.Parameters.Where(
                p => GetParameterGroupName(method.Group, method.Name, p) == parameterGroupName).ToDictionary(
                    CreateParameterGroupProperty,
                    p => p);

            return new ParameterGroup(parameterGroupName, parameterMapping);
        }

        private static string GetParameterGroupName(string methodGroupName, string methodName, Parameter parameter)
        {
            if (parameter.Extensions.ContainsKey(SwaggerExtensions.ParameterGroupExtension))
            {
                JContainer extensionObject = parameter.Extensions[SwaggerExtensions.ParameterGroupExtension] as JContainer;
                if (extensionObject != null)
                {
                    string specifiedGroupName = extensionObject.Value<string>("name");
                    string parameterGroupName;
                    if (specifiedGroupName == null)
                    {
                        string postfix = extensionObject.Value<string>("postfix") ?? "Parameters";
                        parameterGroupName = methodGroupName + "-" + methodName + "-" + postfix;
                    }
                    else
                    {
                        parameterGroupName = specifiedGroupName;
                    }
                    return parameterGroupName;
                }
            }

            return null;
        }

        private static IEnumerable<string> ExtractParameterGroupNames(Method method)
        {
            return method.Parameters.Select(p => GetParameterGroupName(method.Group, method.Name, p)).Where(name => !string.IsNullOrEmpty(name)).Distinct();
        }

        private static IEnumerable<ParameterGroup> ExtractParameterGroups(Method method)
        {
            IEnumerable<string> parameterGroupNames = ExtractParameterGroupNames(method);

            return parameterGroupNames.Select(parameterGroupName => BuildParameterGroup(parameterGroupName, method));
        }

        private static IEnumerable<Method> GetMethodsUsingParameterGroup(IEnumerable<Method> methods, ParameterGroup parameterGroup)
        {
            return methods.Where(m => ExtractParameterGroupNames(m).Contains(parameterGroup.Name));
        }

        private static string GenerateParameterGroupModelText(IEnumerable<Method> methodsWhichUseGroup)
        {
            Func<string, string, string> createOperationDisplayString = (group, name) =>
            {
                return string.IsNullOrEmpty(group) ? name : string.Format(CultureInfo.InvariantCulture, "{0}_{1}", group, name);
            };

            List<Method> methodList = methodsWhichUseGroup.ToList();
            if (methodList.Count == 1)
            {
                Method method = methodList.Single();
                return string.Format(CultureInfo.InvariantCulture, "Additional parameters for the {0} operation.",
                    createOperationDisplayString(method.MethodGroup.Name, method.Name));
            }
            else if (methodList.Count <= 4)
            {
                string operationsString = string.Join(", ", methodList.Select(
                    m => string.Format(CultureInfo.InvariantCulture, createOperationDisplayString(m.MethodGroup.Name, m.Name))));

                return string.Format(CultureInfo.InvariantCulture, "Additional parameters for a set of operations, such as: {0}.", operationsString);
            }
            else
            {
                return "Additional parameters for a set of operations.";
            }
        }

        /// <summary>
        /// Adds the parameter groups to operation parameters.
        /// </summary>
        /// <param name="codeModelient"></param>
        public static void AddParameterGroups(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            HashSet<CompositeType> generatedParameterGroups = new HashSet<CompositeType>();

            foreach (Method method in codeModel.Methods)
            {
                //Copy out flattening transformations as they should be the last
                List<ParameterTransformation> flatteningTransformations = method.InputParameterTransformation.ToList();
                method.InputParameterTransformation.Clear();

                //This group name is normalized by each languages code generator later, so it need not happen here.
                IEnumerable<ParameterGroup> parameterGroups = ExtractParameterGroups(method);

                List<Parameter> parametersToAddToMethod = new List<Parameter>();
                List<Parameter> parametersToRemoveFromMethod = new List<Parameter>();

                foreach (ParameterGroup parameterGroup in parameterGroups)
                {
                    CompositeType parameterGroupType =
                        generatedParameterGroups.FirstOrDefault(item => item.Name.RawValue == parameterGroup.Name);

                    if (parameterGroupType == null)
                    {
                        IEnumerable<Method> methodsWhichUseGroup = GetMethodsUsingParameterGroup(codeModel.Methods, parameterGroup);

                        parameterGroupType = New<CompositeType>(parameterGroup.Name,new
                        {
                            Documentation = GenerateParameterGroupModelText(methodsWhichUseGroup)
                        });
                        generatedParameterGroups.Add(parameterGroupType);

                        //Add to the service client
                        codeModel.Add(parameterGroupType);
                    }

                    foreach (Property property in parameterGroup.ParameterMapping.Keys)
                    {
                        Property matchingProperty = parameterGroupType.Properties.FirstOrDefault(
                                item => item.Name.RawValue == property.Name.RawValue &&
                                        item.IsReadOnly == property.IsReadOnly &&
                                        item.DefaultValue .RawValue== property.DefaultValue.RawValue &&
                                        item.SerializedName.RawValue == property.SerializedName.RawValue);
                        if (matchingProperty == null)
                        {
                            parameterGroupType.Add(property);
                        }
                    }

                    bool isGroupParameterRequired = parameterGroupType.Properties.Any(p => p.IsRequired);

                    //Create the new parameter object based on the parameter group type
                    Parameter newParameter = New<Parameter>(new
                    {
                        Name = parameterGroup.Name,
                        IsRequired = isGroupParameterRequired,
                        Location = ParameterLocation.None,
                        SerializedName = string.Empty,
                        ModelType = parameterGroupType,
                        Documentation = "Additional parameters for the operation"
                    });
                    parametersToAddToMethod.Add(newParameter);

                    //Link the grouped parameters to their parent, and remove them from the method parameters
                    foreach (Property property in parameterGroup.ParameterMapping.Keys)
                    {
                        Parameter p = parameterGroup.ParameterMapping[property];

                        var parameterTransformation = new ParameterTransformation
                        {
                            OutputParameter = p
                        };

                        parameterTransformation.ParameterMappings.Add(new ParameterMapping
                        {
                            InputParameter = newParameter,
                            InputParameterProperty = property.GetClientName()
                        });
                        method.InputParameterTransformation.Add(parameterTransformation);
                        parametersToRemoveFromMethod.Add(p);
                    }
                }
                method.Remove(p => parametersToRemoveFromMethod.Contains(p));
                method.AddRange(parametersToAddToMethod);

                // Copy back flattening transformations if any
                flatteningTransformations.ForEach(t => method.InputParameterTransformation.Add(t));
            }
        }
    }
}
