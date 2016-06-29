// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.IO;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Utilities;

namespace AutoRest.CSharp.Unit.Tests
{
    public class BugTest
    {
        public BugTest()
        {
            Logger.Entries.Clear();
        }
        
        protected MemoryFileSystem CreateMockFilesystem()
        {
            var fs = new MemoryFileSystem();
            fs.Copy(Path.Combine("Resource", "AutoRest.json"));
            return fs;
        }
    }
}