// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;
using System;

namespace AutoRest.CSharp.Unit.Tests
{
    public class NullableBehavior : BugTest
    {
        public NullableBehavior(ITestOutputHelper output) : base(output)
        {
        }

        private async Task<System.Type> GenerateModelType(string modelName)
        {
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // Expected Files
                Assert.True(fileSystem.FileExists($@"GeneratedCode\Models\{modelName}.cs"));

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

                // verify that deprecated_operations are marked correctly
                var resultType = asm.ExportedTypes.FirstOrDefault(each => each.FullName == $"Test.Models.{modelName}");
                Assert.NotNull(resultType);
                return resultType;
            }
        }

        /// <summary>
        /// Check impact of "required" on nullability.
        /// </summary>
        private void CheckForRequiredMemberBehavior(Type modelType, Func<Type, Type> valueTypeSelector)
        {
            var properties = modelType.GetProperties().ToDictionary(prop => prop.Name, prop => valueTypeSelector(prop.PropertyType));

            // check for properties (see NullableBehavior.yaml for naming system)
            Assert.True(properties.ContainsKey("Member000"));
            Assert.True(properties.ContainsKey("Member001"));
            Assert.True(properties.ContainsKey("Member010"));
            Assert.True(properties.ContainsKey("Member011"));
            Assert.True(properties.ContainsKey("Member100"));
            Assert.True(properties.ContainsKey("Member110"));

            // if not required, it must be nullable
            Assert.True(properties["Member000"].IsNullableValueType());
            Assert.True(properties["Member001"].IsNullableValueType());
            Assert.True(properties["Member010"].IsNullableValueType());
            Assert.True(properties["Member011"].IsNullableValueType());

            // if required, it must not be nullable
            Assert.False(properties["Member100"].IsNullableValueType());
            Assert.False(properties["Member110"].IsNullableValueType());
        }

        /// <summary>
        /// Check that all members are not nullable.
        /// </summary>
        private void CheckForNonNullableMembers(Type modelType, Func<Type, Type> valueTypeSelector)
        {
            Assert.True(modelType.GetProperties().All(prop => !valueTypeSelector(prop.PropertyType).IsNullableValueType()));
        }

        /// <summary>
        /// Check that all members are nullable.
        /// </summary>
        private void CheckForNullableMembers(Type modelType, Func<Type, Type> valueTypeSelector)
        {
            Assert.True(modelType.GetProperties().All(prop => valueTypeSelector(prop.PropertyType).IsNullableValueType()));
        }

        /// <summary>
        /// Related: https://github.com/Azure/autorest/issues/816
        /// Nullable int property on response model for element that will always be present.
        /// </summary>
        [Fact]
        public async Task NullableInteger()
        {
            // the value type in question is the property type itself
            Func<Type, Type> selfSelector = propType => propType;

            var resultType = await GenerateModelType("ResultInteger");
            CheckForRequiredMemberBehavior(resultType, selfSelector);

            var resultTypeXNtrue = await GenerateModelType("ResultIntegerXNtrue");
            CheckForNullableMembers(resultTypeXNtrue, selfSelector);

            var resultTypeXNfalse = await GenerateModelType("ResultIntegerXNfalse");
            CheckForNonNullableMembers(resultTypeXNfalse, selfSelector);
        }

        /// <summary>
        /// Related: https://github.com/Azure/autorest/issues/1088
        /// Nullability of Guids (or other structs).
        /// </summary>
        [Fact]
        public async Task NullableGuid()
        {
            // the value type in question is the property type itself
            Func<Type, Type> selfSelector = propType => propType;

            var resultType = await GenerateModelType("ResultGuid");
            CheckForRequiredMemberBehavior(resultType, selfSelector);

            var resultTypeXNtrue = await GenerateModelType("ResultGuidXNtrue");
            CheckForNullableMembers(resultTypeXNtrue, selfSelector);

            var resultTypeXNfalse = await GenerateModelType("ResultGuidXNfalse");
            CheckForNonNullableMembers(resultTypeXNfalse, selfSelector);
        }

        [Fact]
        public async Task NullableListItems()
        {
            // the value type in question is the lists item type (first generic parameter)
            Func<Type, Type> selfSelector = propType => propType.GetGenericArguments()[0];
            
            // "required" does not have impact on list items' nullability - instead: always nullable
            var resultType = await GenerateModelType("ResultList");
            CheckForNullableMembers(resultType, selfSelector);

            var resultTypeXNtrue = await GenerateModelType("ResultListXNtrue");
            CheckForNullableMembers(resultTypeXNtrue, selfSelector);

            var resultTypeXNfalse = await GenerateModelType("ResultListXNfalse");
            CheckForNonNullableMembers(resultTypeXNfalse, selfSelector);
        }

        /// <summary>
        /// Related: https://github.com/Azure/autorest/issues/596
        /// Dictionary value types are always nullable.
        /// </summary>
        [Fact]
        public async Task NullableDictionaryItems()
        {
            // the value type in question is the lists item type (first generic parameter)
            Func<Type, Type> selfSelector = propType => propType.GetGenericArguments()[1];

            // "required" does not have impact on list additional properties' nullability - instead: always nullable
            var resultType = await GenerateModelType("ResultDictionary");
            CheckForNullableMembers(resultType, selfSelector);

            var resultTypeXNtrue = await GenerateModelType("ResultDictionaryXNtrue");
            CheckForNullableMembers(resultTypeXNtrue, selfSelector);

            var resultTypeXNfalse = await GenerateModelType("ResultDictionaryXNfalse");
            CheckForNonNullableMembers(resultTypeXNfalse, selfSelector);
        }
    }
}