// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Xunit;

namespace AutoRest.CSharp.Unit.Tests
{
    public class Bug1161 : BugTest
    {
        [Fact]
        public void DoubleQuestionMarksWhenUsingEnumsInAnArray()
        {
            using (var fileSystem = "Bug1161.yaml".GenerateCodeInto(CreateMockFilesystem()))
            {
                Assert.True(fileSystem.FileExists(@"GeneratedCode\Models\RecurrenceSchedule.cs"));

                var recurrenceSchedule = fileSystem.ReadFileAsText(@"GeneratedCode\Models\RecurrenceSchedule.cs");
                Assert.NotNull(recurrenceSchedule);

                
            }
        }
    }
}