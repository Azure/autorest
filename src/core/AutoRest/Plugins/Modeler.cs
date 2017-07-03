// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Microsoft.Perks.JsonRPC;
using AutoRest.Core.Utilities;
using AutoRest.Swagger;
using AutoRest.Core.Extensibility;
using AutoRest.Core;
using AutoRest.Core.Model;

public class Modeler : NewPlugin
{
    public Modeler(Connection connection, string sessionId) : base(connection, sessionId)
    { }

    protected override async Task<bool> ProcessInternal()
    {
        new Settings
        {
            Namespace = await GetValue("namespace") ?? ""
        };

        var files = await ListInputs();
        if (files.Length != 1)
        {
            return false;
        }

        var content = await ReadFile(files[0]);
        var fs = new MemoryFileSystem();
        fs.WriteAllText(files[0], content);

        var serviceDefinition = SwaggerParser.Parse(fs.ReadAllText(files[0]));
        var modeler = new SwaggerModeler();
        var codeModel = modeler.Build(serviceDefinition);

        var genericSerializer = new ModelSerializer<CodeModel>();
        var modelAsJson = genericSerializer.ToJson(codeModel);

        WriteFile("codeMode.yaml", modelAsJson, null);

        return true;
    }
}