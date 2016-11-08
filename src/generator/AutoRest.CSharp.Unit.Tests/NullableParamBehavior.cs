// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.CSharp.Unit.Tests
{
    public class NullableParamBehavior : BugTest
    {
        public NullableParamBehavior(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     Related: 
        ///     - https://github.com/Azure/autorest/issues/1088
        ///       (C#) Revise of parameter pre checking necessary.
        ///     - https://github.com/Azure/autorest/issues/1554
        ///       C# codegen generates invalid code for boolean parameters
        /// </summary>
        [Fact]
        public async Task NullableParams()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                string generatedCodeFileName = @"GeneratedCode\TestOperations.cs";
                Assert.True(fileSystem.FileExists(generatedCodeFileName));
                var generatedCode = fileSystem.VirtualStore[generatedCodeFileName].ToString();

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();
                
                // filter the errors
                var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                Write(warnings, fileSystem);
                Write(errors, fileSystem);

                // use this to write out all the messages, even hidden ones.
                // Write(result.Messages, fileSystem);

                // Don't proceed unless we have zero warnings.
                Assert.Empty(warnings);
                // Don't proceed unless we have zero Errors.
                Assert.Empty(errors);

                // Should also succeed.
                Assert.True(result.Succeeded);

                // try to load the assembly
                var asm = Assembly.Load(result.Output.GetBuffer());
                Assert.NotNull(asm);
                var testOperations = asm.ExportedTypes.FirstOrDefault(type => type.FullName == "Test.TestOperations");
                Assert.NotNull(testOperations);
                var operation = testOperations.GetMethod("OpWithHttpMessagesAsync");
                Assert.NotNull(operation);
                var parameters = operation.GetParameters();

                for (int propDefault = 0; propDefault < 2; propDefault++)
                {
                    for (int propXNullable = 0; propXNullable < 3; propXNullable++)
                    {
                        for (int propRequired = 0; propRequired < 3; propRequired++)
                        {
                            for (int propReadOnly = 0; propReadOnly < 3; propReadOnly++)
                            {
                                // retrieve param with given configuration
                                string paramName = $"param{propDefault}{propXNullable}{propRequired}{propReadOnly}";
                                var param = parameters.FirstOrDefault(p => p.Name == paramName);
                                Assert.NotNull(param);

                                // ensure that null-checks are there exactly if the parameter is nullable
                                bool isNullable = param.ParameterType.IsNullableValueType();
                                bool isCheckedForNull = generatedCode.Contains($"if ({paramName} != null)");
                                Assert.Equal(isNullable, isCheckedForNull);

                                // ensure that `x-nullable` (if set) determines nullability,
                                // otherwise, consult `required`
                                if (propXNullable < 2)
                                {
                                    Assert.Equal(isNullable, propXNullable == 1);
                                }
                                else
                                {
                                    Assert.Equal(isNullable, propRequired != 1);
                                }
                                
                                // ensure that default value is given except if `required` is set
                                bool hasDefault = param.HasDefaultValue;
                                Assert.Equal(hasDefault, propRequired != 1);

                                // ensure that default value is the one that was specified (if one was specified) 
                                int? defaultValue = param.DefaultValue as int?;
                                if (hasDefault && propDefault == 1)
                                {
                                    Assert.Equal(defaultValue, 42);
                                }

                                // print full table
                                // WriteLine($"{propDefault}\t{propXNullable}\t{propRequired}\t{propReadOnly}\t{isNullable}\t{(hasDefault ? defaultValue.ToString() : "-")}");
                            }
                        }
                    }
                }
            }
        }
        
        [Fact]
        public async Task NullableParamsAzure()
        {
            using (var fileSystem = GenerateCodeForTestFromSpec(codeGenerator: "Azure.CSharp"))
            {
                // Expected Files
                string generatedCodeFileName = @"GeneratedCode\TestOperations.cs";
                Assert.True(fileSystem.FileExists(generatedCodeFileName));
                var generatedCode = fileSystem.VirtualStore[generatedCodeFileName].ToString();

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // filter the errors
                var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                Write(warnings, fileSystem);
                Write(errors, fileSystem);

                // use this to write out all the messages, even hidden ones.
                // Write(result.Messages, fileSystem);

                // Don't proceed unless we have zero warnings.
                Assert.Empty(warnings);
                // Don't proceed unless we have zero Errors.
                Assert.Empty(errors);

                // Should also succeed.
                Assert.True(result.Succeeded);

                // try to load the assembly
                var asm = Assembly.Load(result.Output.GetBuffer());
                Assert.NotNull(asm);
                var testOperations = asm.DefinedTypes.FirstOrDefault(type => type.FullName == "Test.TestOperations");
                Assert.NotNull(testOperations);
                var operation = testOperations.GetMethod("OpWithHttpMessagesAsync");
                Assert.NotNull(operation);
                var parameters = operation.GetParameters();

                for (int propDefault = 0; propDefault < 2; propDefault++)
                {
                    for (int propXNullable = 0; propXNullable < 3; propXNullable++)
                    {
                        for (int propRequired = 0; propRequired < 3; propRequired++)
                        {
                            for (int propReadOnly = 0; propReadOnly < 3; propReadOnly++)
                            {
                                // retrieve param with given configuration
                                string paramName = $"param{propDefault}{propXNullable}{propRequired}{propReadOnly}";
                                var param = parameters.FirstOrDefault(p => p.Name == paramName);
                                Assert.NotNull(param);

                                // ensure that null-checks are there exactly if the parameter is nullable
                                bool isNullable = param.ParameterType.IsNullableValueType();
                                bool isCheckedForNull = generatedCode.Contains($"if ({paramName} != null)");
                                Assert.Equal(isNullable, isCheckedForNull);

                                // ensure that `x-nullable` (if set) determines nullability,
                                // otherwise, consult `required`
                                if (propXNullable < 2)
                                {
                                    Assert.Equal(isNullable, propXNullable == 1);
                                }
                                else
                                {
                                    Assert.Equal(isNullable, propRequired != 1);
                                }

                                // ensure that default value is given except if `required` is set
                                bool hasDefault = param.HasDefaultValue;
                                Assert.Equal(hasDefault, propRequired != 1);

                                // ensure that default value is the one that was specified (if one was specified) 
                                int? defaultValue = param.DefaultValue as int?;
                                if (hasDefault && propDefault == 1)
                                {
                                    Assert.Equal(defaultValue, 42);
                                }

                                // print full table
                                // WriteLine($"{propDefault}\t{propXNullable}\t{propRequired}\t{propReadOnly}\t{isNullable}\t{(hasDefault ? defaultValue.ToString() : "-")}");
                            }
                        }
                    }
                }
            }
        }
    }
}