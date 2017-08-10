// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Threading.Tasks;
using Microsoft.Perks.JsonRPC;
using AutoRest.Core.Utilities;
using System;
using System.Text.RegularExpressions;

public class CSharpSimplifier : NewPlugin
{
    public CSharpSimplifier(Connection connection, string sessionId) : base(connection, sessionId)
    { }

    protected override async Task<bool> ProcessInternal()
    {
        var fs = new MemoryFileSystem();

        // setup filesystem
        var files = await ListInputs();
        foreach (var file in files)
        {
            fs.WriteAllText(file, await ReadFile(file));
        }

        // simplify
        new AutoRest.Simplify.CSharpSimplifier().Run(fs).ConfigureAwait(false).GetAwaiter().GetResult();

        // write out files
        var outFiles = fs.GetFiles("", "*", System.IO.SearchOption.AllDirectories);
        foreach (var outFile in outFiles)
        {
            WriteFile(outFile, fs.ReadAllText(outFile), null);
        }

        return true;
    }
}