// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Microsoft.Perks.JsonRPC;
using AutoRest.Core.Extensibility;
using AutoRest.Core;
using AutoRest.Core.Parsing;
using System.Linq;

public class Generator : NewPlugin
{
  private string codeGenerator;

  public Generator(string codeGenerator, Connection connection, string sessionId) : base(connection, sessionId)
  {
    this.codeGenerator = codeGenerator;
  }

  protected override async Task<bool> ProcessInternal()
  {
    // get internal name
    var language = new[] {
        "CSharp",
        "Ruby",
        "NodeJS",
        "Python",
        "Go",
        "Java",
        "AzureResourceSchema" }
      .Where(x => x.ToLowerInvariant() == codeGenerator)
      .FirstOrDefault();

    if (language == null)
    {
       throw new Exception($"Language '{codeGenerator}' unknown.");
    }

    // build settings
    new Settings
    {
      Namespace = await GetValue("namespace") ?? "",
      ClientName = await GetValue("override-client-name"),
      PayloadFlatteningThreshold = await GetValue<int?>("payload-flattening-threshold") ?? 0,
      AddCredentials = await GetValue<bool?>("add-credentials") ?? false,
    };
    var header = await GetValue("license-header");
    if (header != null)
    {
      Settings.Instance.Header = header;
    }
    Settings.Instance.CustomSettings.Add("InternalConstructors", await GetValue<bool?>("use-internal-constructors") ?? false);
    Settings.Instance.CustomSettings.Add("SyncMethods", await GetValue("sync-methods") ?? "essential");
    Settings.Instance.CustomSettings.Add("UseDateTimeOffset", await GetValue<bool?>("use-datetimeoffset") ?? false);
    if (codeGenerator == "ruby" || codeGenerator == "python")
    {
      // TODO: sort out matters here entirely instead of relying on Input being read somewhere...
      var inputFile = await GetValue<object>("input-file");
      if (inputFile is string)
      {
        Settings.Instance.Input = inputFile as string;
      }
      Settings.Instance.PackageName = await GetValue("package-name");
      Settings.Instance.PackageVersion = await GetValue("package-version");
    }

    // process
    var files = await ListInputs();
    if (files.Length != 1)
    {
      return false;
    }

    var plugin = ExtensionsLoader.GetPlugin(
        (await GetValue<bool?>("azure-arm") ?? false ? "Azure." : "") + 
        language +
        (await GetValue<bool?>("fluent") ?? false ? ".Fluent" : ""));
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