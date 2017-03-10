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

public class Generator : NewPlugin
{
  private string codeGenerator;

  public Generator(Connection connection, string sessionId) : base(connection, sessionId)
  { }

  protected override async Task<bool> ProcessInternal()
  {
    new Settings { };
    var codeGenerator = await GetValue("codeGenerator");

    var files = await ListInputs();
    if (files.Length != 1)
    {
      return false;
    }

    var content = await ReadFile(files[0]);
    var fs = new MemoryFileSystem();
    fs.WriteAllText(files[0], content);

    var serviceDefinition = SwaggerParser.Load(files[0], fs);
    var modeler = new SwaggerModeler();
    var codeModel = modeler.Build(serviceDefinition);
    var plugin = ExtensionsLoader.GetPlugin(codeGenerator);

    try
    {
        var genericSerializer = new ModelSerializer<CodeModel>();
        var modelAsJson = genericSerializer.ToJson(codeModel);

        using (plugin.Activate())
        {
            codeModel = plugin.Serializer.Load(modelAsJson);
            codeModel = plugin.Transformer.TransformCodeModel(codeModel);
            plugin.CodeGenerator.Generate(codeModel).GetAwaiter().GetResult();
        }
    }
    catch (Exception exception)
    {
        return false;
    }

    // write out files
    var outFS = Settings.Instance.FileSystemOutput;
    var outFiles = outFS.GetFiles("", "*", System.IO.SearchOption.AllDirectories);
    foreach (var outFile in outFiles)
    {
        WriteFile(outFile, outFS.ReadAllText(outFile), null);
    }

    return true;
  }
}