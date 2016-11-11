// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Xunit;
using Xunit.Abstractions;
using System.Reflection;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1161 : BugTest
    {
        public Bug1161(ITestOutputHelper output) : base(output)
        {
        }

        /// <summary>
        ///     https://github.com/Azure/autorest/issues/1161
        ///     Autorest generates double ?? when using an enum in an array and as a type.
        /// </summary>
        [Fact]
        public async Task DoubleQuestionMarksWhenUsingEnumsInAnArray()
        {
            // simplified test pattern for unit testing aspects of code generation
            using (var fileSystem = GenerateCodeForTestFromSpec())
            {
                // check for the expected class.
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\RecurrenceSchedule.cs"));

                var result = await Compile(fileSystem);

                // filter the warnings
                var warnings = result.Messages.Where(
                    each => each.Severity == DiagnosticSeverity.Warning
                            && !SuppressWarnings.Contains(each.Id)).ToArray();

                // filter the errors
                var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();

                Write(warnings, fileSystem);
                Write(errors, fileSystem);

                // Don't proceed unless we have zero Warnings.
                Assert.Empty(warnings);

                // Don't proceed unless we have zero Errors.
                Assert.Empty(errors);

                // Should also succeed.
                Assert.True(result.Succeeded);

                // try to load the assembly
                var asm = Assembly.Load(result.Output.GetBuffer());
                Assert.NotNull(asm);

                // verify that we have the class we expected
                var recurrenceScheduleObject = asm.ExportedTypes.FirstOrDefault(each => each.FullName == "Test.Models.RecurrenceSchedule");
                Assert.NotNull(recurrenceScheduleObject);
                // verify the property is generated 
                var prop = recurrenceScheduleObject.GetProperty("WeekDays");
                Assert.NotNull(prop);

                var propGenericType = prop.PropertyType.GenericTypeArguments[0].GenericTypeArguments[0];
                Assert.Equal(propGenericType.Name, "DayOfWeek");
                Assert.True(propGenericType.IsEnum);
                
            }
        }
    }
}