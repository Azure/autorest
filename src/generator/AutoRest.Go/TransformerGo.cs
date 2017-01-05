// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Logging;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Go.Model;
using AutoRest.Go.Properties;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;

namespace AutoRest.Go
{
    public class TransformerGo : CodeModelTransformer<CodeModelGo>
    {
        private readonly Dictionary<IModelType, IModelType> _normalizedTypes;

        public TransformerGo()
        {
            _normalizedTypes = new Dictionary<IModelType, IModelType>();
        }

        public override CodeModelGo TransformCodeModel(CodeModel cm)
        {
            var cmg = cm as CodeModelGo;

            SwaggerExtensions.ProcessGlobalParameters(cmg);
            // Add the current package name as a reserved keyword
            CodeNamerGo.Instance.ReserveNamespace(cm.Namespace);
            FixStutteringTypeNames(cmg);
            TransformEnumTypes(cmg);
            TransformMethods(cmg);
            TransformModelTypes(cmg);

            return cmg;
        }

        private void TransformEnumTypes(CodeModelGo cmg)
        {
            // fix up any enum types that are missing a name.
            // NOTE: this must be done before the next code block
            foreach (var mt in cmg.ModelTypes)
            {
                foreach (var property in mt.Properties)
                {
                    // gosdk: For now, inherit Enumerated type names from the composite type field name
                    if (property.ModelType is EnumTypeGo)
                    {
                        var enumType = property.ModelType as EnumTypeGo;

                        if (!enumType.IsNamed)
                        {
                            enumType.SetName(property.Name);
                        }
                    }
                }
            }

            // And add any others with a defined name and value list (but not already located)
            foreach (var mt in cmg.ModelTypes)
            {
                var namedEnums = mt.Properties.Where(p => p.ModelType is EnumTypeGo && (p.ModelType as EnumTypeGo).IsNamed);
                foreach (var p in namedEnums)
                {
                    if (!cmg.EnumTypes.Any(etm => etm.Equals(p.ModelType)))
                    {
                        cmg.Add(new EnumTypeGo(p.ModelType as EnumType));
                    }
                };
            }

            // now normalize the names
            // NOTE: this must be done after all enum types have been accounted for
            foreach (var enumType in cmg.EnumTypes)
            {
                enumType.SetName(CodeNamer.Instance.GetTypeName(enumType.Name.FixedValue));
                foreach (var v in enumType.Values)
                {
                    v.Name = CodeNamer.Instance.GetEnumMemberName(v.Name);
                }
            }

            // Ensure all enumerated type values have the simplest possible unique names
            // -- The code assumes that all public type names are unique within the client and that the values
            //    of an enumerated type are unique within that type. To safely promote the enumerated value name
            //    to the top-level, it must not conflict with other existing types. If it does, prepending the
            //    value name with the (assumed to be unique) enumerated type name will make it unique.

            // First, collect all type names (since these cannot change)
            var topLevelNames = new HashSet<string>();
            cmg.ModelTypes
                .ForEach(mt => topLevelNames.Add(mt.Name));

            // Then, note each enumerated type with one or more conflicting values and collect the values from
            // those enumerated types without conflicts.  do this on a sorted list to ensure consistent naming
            cmg.EnumTypes.Cast<EnumTypeGo>().OrderBy(etg => etg.Name.Value)
                .ForEach(em =>
                {
                    if (em.Values.Where(v => topLevelNames.Contains(v.Name) || CodeNamerGo.Instance.UserDefinedNames.Contains(v.Name)).Count() > 0)
                    {
                        em.HasUniqueNames = false;
                    }
                    else
                    {
                        em.HasUniqueNames = true;
                        topLevelNames.UnionWith(em.Values.Select(ev => ev.Name).ToList());
                    }
                });

            // add documentation comment if there aren't any
            cmg.EnumTypes.Cast<EnumTypeGo>()
                .ForEach(em =>
                {
                    if (string.IsNullOrEmpty(em.Documentation))
                    {
                        em.Documentation = string.Format("{0} enumerates the values for {1}.", em.Name, em.Name.FixedValue.ToPhrase());
                    }
                });
        }

        private void TransformModelTypes(CodeModelGo cmg)
        {
            foreach (var ctg in cmg.ModelTypes.Cast<CompositeTypeGo>())
            {
                var name = ctg.Name.FixedValue.TrimPackageName(cmg.Namespace);

                // ensure that the candidate name isn't already in use
                if (name != ctg.Name && cmg.ModelTypes.Any(mt => mt.Name == name))
                {
                    name = $"{name}Type";
                }

                if (CodeNamerGo.Instance.UserDefinedNames.Contains(name))
                {
                    name = $"{name}{cmg.Namespace.Capitalize()}";
                }

                ctg.SetName(name);
            }

            // Find all methods that returned paged results

            cmg.Methods.Cast<MethodGo>()
                .Where(m => m.IsPageable).ToList()
                .ForEach(m =>
                {
                    if (!cmg.PagedTypes.ContainsKey(m.ReturnValue().Body))
                    {
                        cmg.PagedTypes.Add(m.ReturnValue().Body, m.NextLink());
                    }

                    if (!m.NextMethodExists(cmg.Methods.Cast<MethodGo>()))
                    {
                        cmg.NextMethodUndefined.Add(m.ReturnValue().Body);
                    }
                });

            // Mark all models returned by one or more methods and note any "next link" fields used with paged data
            cmg.ModelTypes.Cast<CompositeTypeGo>()
                .Where(mtm =>
                {
                    return cmg.Methods.Cast<MethodGo>().Any(m => m.HasReturnValue() && m.ReturnValue().Body.Equals(mtm));
                }).ToList()
                .ForEach(mtm =>
                {
                    mtm.IsResponseType = true;
                    if (cmg.PagedTypes.ContainsKey(mtm))
                    {
                        mtm.NextLink = CodeNamerGo.PascalCaseWithoutChar(cmg.PagedTypes[mtm], '.');
                        mtm.PreparerNeeded = cmg.NextMethodUndefined.Contains(mtm);
                    }
                });
        }

        private void TransformMethods(CodeModelGo cmg)
        {
            foreach (var mg in cmg.MethodGroups)
            {
                mg.Transform(cmg);
            }

            var wrapperTypes = new Dictionary<string, CompositeTypeGo>();
            foreach (var method in cmg.Methods)
            {
                ((MethodGo)method).Transform(cmg);

                var scope = new VariableScopeProvider();
                foreach (var parameter in method.Parameters)
                {
                    parameter.Name = scope.GetVariableName(parameter.Name);
                }

                // fix up method return types
                if (method.ReturnType.Body.ShouldBeSyntheticType())
                {
                    var ctg = new CompositeTypeGo(method.ReturnType.Body);
                    if (wrapperTypes.ContainsKey(ctg.Name))
                    {
                        method.ReturnType = new Response(wrapperTypes[ctg.Name], method.ReturnType.Headers);
                    }
                    else
                    {
                        wrapperTypes.Add(ctg.Name, ctg);
                        cmg.Add(ctg);
                        method.ReturnType = new Response(ctg, method.ReturnType.Headers);
                    }
                }
            }
        }

        private void FixStutteringTypeNames(CodeModelGo cmg)
        {
            // Trim the package name from exported types; append a suitable qualifier, if needed, to avoid conflicts.
            var exportedTypes = new HashSet<object>();
            exportedTypes.UnionWith(cmg.EnumTypes);
            exportedTypes.UnionWith(cmg.Methods);
            exportedTypes.UnionWith(cmg.ModelTypes);

            var stutteringTypes = exportedTypes
                                    .Where(exported =>
                                        (exported is IModelType && (exported as IModelType).Name.FixedValue.StartsWith(cmg.Namespace, StringComparison.OrdinalIgnoreCase)) ||
                                        (exported is Method && (exported as Method).Name.FixedValue.StartsWith(cmg.Namespace, StringComparison.OrdinalIgnoreCase)));

            if (stutteringTypes.Any())
            {
                Logger.Instance.Log(Category.Warning, string.Format(CultureInfo.InvariantCulture, Resources.NamesStutter, stutteringTypes.Count()));
                stutteringTypes.ForEach(exported =>
                    {
                        var name = exported is IModelType
                                        ? (exported as IModelType).Name
                                        : (exported as Method).Name;

                        Logger.Instance.Log(Category.Warning, string.Format(CultureInfo.InvariantCulture, Resources.StutteringName, name));

                        name = name.FixedValue.TrimPackageName(cmg.Namespace);

                        var nameInUse = exportedTypes
                                            .Any(et => (et is IModelType && (et as IModelType).Name.Equals(name)) || (et is Method && (et as Method).Name.Equals(name)));
                        if (exported is EnumType)
                        {
                            (exported as EnumType).Name.FixedValue = CodeNamerGo.AttachTypeName(name, cmg.Namespace, nameInUse, "Enum");
                        }
                        else if (exported is CompositeType)
                        {
                            (exported as CompositeType).Name.FixedValue = CodeNamerGo.AttachTypeName(name, cmg.Namespace, nameInUse, "Type");
                        }
                        else if (exported is Method)
                        {
                            (exported as Method).Name = CodeNamerGo.AttachTypeName(name, cmg.Namespace, nameInUse, "Method");
                        }
                    });
            }
        }
    }
}
