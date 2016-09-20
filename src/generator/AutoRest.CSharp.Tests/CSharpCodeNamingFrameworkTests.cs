// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Globalization;
using System.Linq;
using System.Reflection.Metadata;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.CSharp.Model;
using AutoRest.CSharp.Tests;
using Xunit;
using Parameter = AutoRest.Core.Model.Parameter;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.Tests
{
    [Collection("AutoRest Tests")]
    public class CSharpCodeNamingFrameworkTests
    {
        [Fact]
        public void TypeNormalizationTest()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "azure always rocks!";
            codeModel.Add(New<Property>(new
            {
                Name = "&%$ i rock too!",
                ModelType =  New<PrimaryType>(KnownPrimaryType.Int)
            }));
            codeModel.Add(New<Property>(new 
            {
                Name = "some-other-stream",
                ModelType = New<PrimaryType>(KnownPrimaryType.Stream)
            }));

            var customObjectType = New<CompositeType>("!@#$%^&*()abc");
            customObjectType.SerializedName = "!@#$%^&*()abc";
            customObjectType.Add(New<Property>(new
            {
                Name = "boolean-property",
                ModelType = New<PrimaryType>(KnownPrimaryType.Boolean)
            }));
            customObjectType.Add(New<Property>(new 
            {
                Name = "some^dateTime_sequence",
                ModelType = New<SequenceType>(new 
                {
                    ElementType = New<PrimaryType>(KnownPrimaryType.DateTime)
                })
            }));

            var baseType = New<CompositeType>("baseType");
            baseType.SerializedName = "baseType";
            baseType.Add(New <Property>(new 
            {
                Name = "boolean-property",
                SerializedName = "boolean-property",
                ModelType = New<PrimaryType>(KnownPrimaryType.Boolean)
            }));
            baseType.BaseModelType = baseType;
            baseType.Add(New<Property>(new 
            {
                Name = "self-property",
                SerializedName = "self-property",
                ModelType = baseType
            }));

            customObjectType.BaseModelType = baseType;

            codeModel.Add(customObjectType);
            codeModel.Add(baseType);

            var framework = new CSharpCodeNamer();
#if gws_removed
            framework.NormalizeClientModel(codeModel);
#endif
            Assert.Equal("Azurealwaysrocks", codeModel.Name);
            Assert.Equal("Abc", codeModel.ModelTypes.First(m => m.Name == "Abc").Name);
            Assert.Equal("!@#$%^&*()abc", codeModel.ModelTypes.First(m => m.Name == "Abc").SerializedName);
            Assert.Equal("BooleanProperty", codeModel.ModelTypes.First(m => m.Name == "Abc").Properties[0].Name);
            Assert.Equal("SomedateTimeSequence", codeModel.ModelTypes.First(m => m.Name == "Abc").Properties[1].Name);
            Assert.Equal("BaseType", codeModel.ModelTypes.First(m => m.Name == "BaseType").Name);
            Assert.Equal("baseType", codeModel.ModelTypes.First(m => m.Name == "BaseType").SerializedName);
            Assert.Equal("BooleanProperty", codeModel.ModelTypes.First(m => m.Name == "BaseType").Properties[0].Name);
            Assert.Equal("boolean-property", codeModel.ModelTypes.First(m => m.Name == "BaseType").Properties[0].SerializedName);
            Assert.Equal("SelfProperty", codeModel.ModelTypes.First(m => m.Name == "BaseType").Properties[1].Name);
            Assert.Equal("self-property", codeModel.ModelTypes.First(m => m.Name == "BaseType").Properties[1].SerializedName);
        }

        [Fact(Skip = "gws - disabled, because normaliztion not done anymore")]
        public void TypeNormalizationWithComplexTypesTest()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "azure always rocks!";

            var childObject = New<CompositeType>("child");
            childObject.Add(New<Property>(new 
            {
                Name = "childProperty",
                ModelType = New<PrimaryType>(KnownPrimaryType.String)
            }));

            var customObjectType = New<CompositeType>("sample");
            customObjectType.Add(New<Property>(new
            {
                Name = "child",
                ModelType = childObject
            }));
            customObjectType.Add(New<Property>(new
            {
                Name = "childList",
                ModelType = New<SequenceType>(new
                {
                    ElementType = childObject
                })
            }));
            customObjectType.Add(New<Property>(new
            {
                Name = "childDict",
                ModelType = New<DictionaryType>(new
                {
                    ValueType = childObject
                })
            }));

            codeModel.Add(customObjectType);
            codeModel.Add(childObject);

            var framework = new CSharpCodeNamer();
#if gws_removed
            framework.NormalizeClientModel(codeModel);
            framework.ResolveNameCollisions(codeModel, "SampleNs", "SampleNs.Models");
#endif


            Assert.Equal("Sample", codeModel.ModelTypes.First(m => m.Name == "Sample").Name);
            Assert.Equal("Child", codeModel.ModelTypes.First(m => m.Name == "Sample").Properties[0].Name);
            Assert.Equal("Child", codeModel.ModelTypes.First(m => m.Name == "Sample").Properties[0].ModelType.Name);
            Assert.Equal("ChildList", codeModel.ModelTypes.First(m => m.Name == "Sample").Properties[1].Name);
            Assert.Equal("System.Collections.Generic.IList<Child>", codeModel.ModelTypes.First(m => m.Name == "Sample").Properties[1].ModelType.Name);
            Assert.Equal("ChildDict", codeModel.ModelTypes.First(m => m.Name == "Sample").Properties[2].Name);
            Assert.Equal("System.Collections.Generic.IDictionary<string, Child>", codeModel.ModelTypes.First(m => m.Name == "Sample").Properties[2].ModelType.Name);
            Assert.Equal("Child", codeModel.ModelTypes.First(m => m.Name == "Child").Name);
            Assert.Equal("string", codeModel.ModelTypes.First(m => m.Name == "Child").Properties[0].ModelType.Name);
        }

        [Fact]
        public void VerifyMethodRenaming()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "azure always rocks!";

            var customObjectType = New<CompositeType>("!@#$%^&*()abc");
            customObjectType.Add(New<Property>(new
            {
                Name = "boolean-property",
                ModelType = New<PrimaryType>(KnownPrimaryType.Boolean)
            }));
            codeModel.Add(New<Method>(new
            {
                Name = " method name with lots of spaces",
                Group = "#$% group with lots of-weird-characters",
                ReturnType = new Response(customObjectType, null)
            }));

            var framework = new CSharpCodeNamer();
#if gws_removed
            framework.NormalizeClientModel(codeModel);
#endif
            Assert.Equal("Methodnamewithlotsofspaces", codeModel.Methods[0].Name);
            Assert.Equal("GroupwithlotsofWeirdCharacters", codeModel.Methods[0].Group);
            Assert.Equal("Abc", codeModel.Methods[0].ReturnType.Body.Name);
        }

        [Fact]
        public void NameCollisionTestWithoutNamespace()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "azure always rocks!";

            var customObjectType = New<CompositeType>("azure always rocks!");

            var baseType = New<CompositeType>("azure always rocks!");

            codeModel.Add(New<Method>(new
            {
                Name = "azure always rocks!",
                Group = "azure always rocks!",
                ReturnType = new Response(customObjectType, null)
            }));

            codeModel.Add(customObjectType);
            codeModel.Add(baseType);

            var framework = new CSharpCodeNamer();
#if gs_removed
            framework.ResolveNameCollisions(codeModel, null, null);
#endif 
            Assert.Equal("azure always rocks!Client", codeModel.Name);
            Assert.Equal("azure always rocks!Operations", codeModel.MethodGroupNames.First());
            Assert.Equal("azure always rocks!", codeModel.Methods[0].Name);
            Assert.Equal("azure always rocks!", codeModel.ModelTypes.First(m => m.Name == "azure always rocks!").Name);
        }

        [Fact]
        public void NameCollisionTestWithNamespace()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "AzureAlwaysRocks";

            var customObjectType = New<CompositeType>("AzureAlwaysRocks");
            

            var baseType = New<CompositeType>("AzureAlwaysRocks");

            codeModel.Add(New<Method>(new
            {
                Name = "AzureAlwaysRocks",
                Group = "AzureAlwaysRocks",
                ReturnType = new Response(customObjectType, null)
            }));

            codeModel.Add(customObjectType);
            codeModel.Add(baseType);

            var framework = new CSharpCodeNamer();
#if _gs_removed
            framework.ResolveNameCollisions(codeModel, "AzureAlwaysRocks", "AzureAlwaysRocks.Models");
#endif 
            Assert.Equal("AzureAlwaysRocksClient", codeModel.Name);
            Assert.Equal("AzureAlwaysRocksOperations", codeModel.MethodGroupNames.First());
            Assert.Equal("AzureAlwaysRocks", codeModel.Methods[0].Name);
            Assert.Equal("AzureAlwaysRocksModel", codeModel.ModelTypes.First(m => m.Name == "AzureAlwaysRocksModel").Name);
        }

        [Fact(Skip="gws - disabled, because normaliztion not done anymore")]
        public void SequenceWithRenamedComplexType()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "azure always rocks!";

            var complexType = New<CompositeType>("Greetings");

            codeModel.Add(New<Method>(new
            {
                Name = "List",
                ReturnType = new Response(New<SequenceType>(new { ElementType = complexType }), null)
            }));

            codeModel.Add(New<Method>(new
            {
                Name = "List2",
                ReturnType = new Response(New<DictionaryType>(new { ValueType = complexType }), null)
            }));

            codeModel.Add(complexType);

            using (new Context().Activate())
            {
                var settings = new Settings {Namespace = "Polar.Greetings"};
                var codeGenerator = new CSharpCodeGenerator();
#if gws_remove
            //codeGenerator.NormalizeClientModel(codeModel);
#endif
            Assert.Equal("GreetingsModel", complexType.Name);
            Assert.Equal("System.Collections.Generic.IList<GreetingsModel>", codeModel.Methods[0].ReturnType.Body.Name);
            Assert.Equal("System.Collections.Generic.IDictionary<string, GreetingsModel>", codeModel.Methods[1].ReturnType.Body.Name);
            }
        }

        [Fact(Skip = "TODO: Test is not correct.")]
        public void VerifyInputMappingsForFlattening()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "test service client";

            var customObjectType = New<CompositeType>("Foo");
            customObjectType.Add(New<Property>(new
            {
                Name = "A",
                ModelType = New<PrimaryType>(KnownPrimaryType.Boolean)
            }));
            customObjectType.Add(New<Property>(new
            {
                Name = "B",
                ModelType = New<PrimaryType>(KnownPrimaryType.String)
            }));
            var method = New<Method>(new
            {
                Name = "method1",
                Group = "mGroup",
                ReturnType = new Response(customObjectType, null)
            });
            var outputParameter = New<Parameter>(new { Name = "body", ModelType = customObjectType });
            codeModel.Add(method);
            method.Add(New<Parameter>(new { Name = "paramA", ModelType = New<PrimaryType>(KnownPrimaryType.Boolean), SerializedName = "paramA" }));
            method.Add(New<Parameter>(new { Name = "paramB", ModelType = New<PrimaryType>(KnownPrimaryType.String), SerializedName = "paramB" }));
            method.InputParameterTransformation.Add(new ParameterTransformation
            {
                OutputParameter = outputParameter
            });
            method.InputParameterTransformation[0].ParameterMappings.Add(new ParameterMapping
            {
                InputParameter = method.Parameters.FirstOrDefault(),
                OutputParameterProperty = "A"
            });
            method.InputParameterTransformation[0].ParameterMappings.Add(new ParameterMapping 
            { 
                InputParameter = method.Parameters.Skip(1).FirstOrDefault(),
                OutputParameterProperty = "B"
            });

            MethodCs templateModel = method as MethodCs;
            templateModel.SyncMethods = SyncMethodsGenerationMode.All;

            var output = templateModel.BuildInputMappings();
            System.Console.WriteLine(output);
            string expected =
          @"Foo body = default(Foo);
            if (paramA != null || paramB != null)
            {
                body = new Foo();
                body.A = paramA;
                body.B = paramB;
            }";

            MultilineAreEqual(expected, output.Trim());
        }

        [Fact(Skip = "TODO: This does not work correctly.")]
        public void VerifyInputMappingsForGrouping()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "test service client";

            var customObjectType = New<CompositeType>("Foo");
            customObjectType.Add(New<Property>(new 
            {
                Name = "A",
                ModelType = New<PrimaryType>(KnownPrimaryType.Boolean)
            }));
            customObjectType.Add(New<Property>(new
            {
                Name = "B",
                ModelType = New<PrimaryType>(KnownPrimaryType.String)
            }));
            var method = New<Method>(new
            {
                Name = "method1",
                Group = "mGroup",
                ReturnType = new Response(customObjectType, null)
            });
            var inputParameter = New<Parameter>(new { Name = "body", ModelType = customObjectType });
            codeModel.Add(method);
            method.Add(inputParameter);
            method.InputParameterTransformation.Add(new ParameterTransformation
            {
                OutputParameter = New<Parameter>(new { Name = "paramA", ModelType = New<PrimaryType>(KnownPrimaryType.String), SerializedName = "paramA" })
            });
            method.InputParameterTransformation.Last().ParameterMappings.Add(new ParameterMapping
            {
                InputParameter = inputParameter,
                InputParameterProperty = "A"
            });
            method.InputParameterTransformation.Add(new ParameterTransformation
            {
                OutputParameter = New<Parameter>(new { Name = "paramB", ModelType = New<PrimaryType>(KnownPrimaryType.String), SerializedName = "paramB" })
            });
            method.InputParameterTransformation.Last().ParameterMappings.Add(new ParameterMapping
            {
                InputParameter = inputParameter,
                InputParameterProperty = "B"
            });

            MethodCs templateModel = method as MethodCs;
            templateModel.SyncMethods = SyncMethodsGenerationMode.All;

            var output = templateModel.BuildInputMappings();
            string expected =
          @"String paramA = default(String);
            if (body != null)
            {
                paramA = body.A;
            }
            String paramB = default(String);
            if (body != null)
            {
                paramB = body.B;
            }";

            MultilineAreEqual(expected, output.Trim());
        }

        [Fact (Skip = "TODO: Implement more robust mapping for resource transformation")]
        public void VerifyInputMappingsForResources()
        {
            var codeModel = New<CodeModel>();
            codeModel.Name = "test service client";

            var flattenedPropertyType = New<CompositeType>("FooFlattened");
            flattenedPropertyType.Add(New<Property>(new
            {
                Name = "Sku",
                ModelType = New<PrimaryType>(KnownPrimaryType.String)
            }));
            flattenedPropertyType.Add(New<Property>(new
            {
                Name = "ProvState",
                ModelType = New<PrimaryType>(KnownPrimaryType.String)
            }));
            flattenedPropertyType.Add(New<Property>(new
            {
                Name = "Id",
                ModelType = New<PrimaryType>(KnownPrimaryType.Int)
            }));

            var customObjectPropertyType = New<CompositeType>("FooProperty");

            customObjectPropertyType.Add(New<Property>(new
            {
                Name = "Sku",
                ModelType = New<PrimaryType>(KnownPrimaryType.String)
            }));
            customObjectPropertyType.Add(New<Property>(new
            {
                Name = "ProvState",
                ModelType = New<PrimaryType>(KnownPrimaryType.String)
            }));

            var customObjectType = New<CompositeType>("Foo");
            customObjectType.Add(New<Property>(new
            {
                Name = "Property",
                ModelType = customObjectPropertyType
            }));
            customObjectType.Add(New<Property>(new
            {
                Name = "Id",
                ModelType = New<PrimaryType>(KnownPrimaryType.Int)
            }));

            var method = New<Method>(new
            {
                Name = "method1",
                Group = "mGroup",
                ReturnType = new Response(flattenedPropertyType, null)
            });
            var inputParameter = New<Parameter>(new { Name = "prop", ModelType = flattenedPropertyType });
            codeModel.Add(method);
            method.Add(inputParameter);
            method.InputParameterTransformation.Add(new ParameterTransformation
            {
                OutputParameter = New<Parameter>(new { Name = "body", ModelType = customObjectType, SerializedName = "body" })
            });
            method.InputParameterTransformation.Last().ParameterMappings.Add(new ParameterMapping
            {
                InputParameter = inputParameter,
                InputParameterProperty = "Id",
                OutputParameterProperty = "Id"
            });
            method.InputParameterTransformation.Last().ParameterMappings.Add(new ParameterMapping
            {
                InputParameter = inputParameter,
                InputParameterProperty = "Sku",
                OutputParameterProperty = "Property.Sku"
            });
            method.InputParameterTransformation.Last().ParameterMappings.Add(new ParameterMapping
            {
                InputParameter = inputParameter,
                InputParameterProperty = "ProvState",
                OutputParameterProperty = "Property.ProvState"
            });            

            MethodCs templateModel = method as MethodCs;
            templateModel.SyncMethods = SyncMethodsGenerationMode.All;

            var output = templateModel.BuildInputMappings();
            string expected =
          @"String paramA = null;
            if (body != null)
            {
                paramA = body.A;
            }
            String paramB = default(String);
            if (body != null)
            {
                paramB = body.B;
            }";

            MultilineAreEqual(expected, output.Trim());
        }

        private static void MultilineAreEqual(string expectedText, string actualText)
        {
            string[] expectedLines = expectedText.Split('\n').Select(p => p.TrimEnd('\r')).ToArray();
            string[] actualLines = actualText.Split('\n').Select(p => p.TrimEnd('\r')).ToArray();

            Assert.Equal(expectedLines.Length, actualLines.Length);

            for (int i = 0; i < expectedLines.Length; i++)
            {
                Assert.True(expectedLines[i].Trim().Equals(actualLines[i].Trim(), System.StringComparison.OrdinalIgnoreCase),
                    string.Format(CultureInfo.InvariantCulture, "Difference on line {0}.\r\nExpected: {1}\r\nActual: {2}", i, expectedLines[i], actualLines[i]));
            }
        }
    }
}