// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Microsoft.Perks.JsonRPC;
using AutoRest.Core.Extensibility;
using AutoRest.Core;
using AutoRest.Core.Parsing;

public class Generator : NewPlugin
{
  public Generator(Connection connection, string sessionId) : base(connection, sessionId)
  { }

  protected override async Task<bool> ProcessInternal()
  {
    var codeGenerator = await GetValue("codeGenerator");

    // build settings
    new Settings
    {
      Namespace = await GetValue("namespace") ?? "",
      ClientName = await GetValue("clientNameOverride"),
      PayloadFlatteningThreshold = await GetValue<int?>("payload-flattening-threshold") ?? 0,
      AddCredentials = await GetValue<bool?>("add-credentials") ?? false,
    };
    var header = await GetValue("license-header");
    if (header != null)
    {
      Settings.Instance.Header = header;
    }
    Settings.Instance.CustomSettings.Add("InternalConstructors", await GetValue<bool?>("internalConstructors") ?? false);
    Settings.Instance.CustomSettings.Add("SyncMethods", await GetValue("sync-methods") ?? "essential");
    Settings.Instance.CustomSettings.Add("UseDateTimeOffset", await GetValue<bool?>("useDateTimeOffset") ?? false);
    if (codeGenerator.EndsWith("Ruby"))
    {
      Settings.Instance.PackageName = await GetValue("package-name") ?? "client";
    }

    // process
    var files = await ListInputs();
    if (files.Length != 1)
    {
      return false;
    }

    var plugin = ExtensionsLoader.GetPlugin(codeGenerator);
    var modelAsJson = (await ReadFile(files[0])).EnsureYamlIsJson();

    using (plugin.Activate())
    {
        var codeModel = plugin.Serializer.Load(modelAsJson);
        codeModel = plugin.Transformer.TransformCodeModel(codeModel);
        plugin.CodeGenerator.Generate(codeModel).GetAwaiter().GetResult();
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