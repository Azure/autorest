// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Threading.Tasks;
using Microsoft.Perks.JsonRPC;
using AutoRest.Core.Extensibility;
using AutoRest.Core;
using AutoRest.Core.Parsing;
using System.Linq;
using AutoRest.Swagger.Model;
using AutoRest.Swagger;
using static AutoRest.Core.Utilities.DependencyInjection;

public class Generator : NewPlugin
{
    private string codeGenerator;

    public Generator(string codeGenerator, Connection connection, string sessionId) : base(connection, sessionId)
    {
        this.codeGenerator = codeGenerator;
    }

    private T GetXmsCodeGenSetting<T>(ServiceDefinition sd, string name)
    {
        try
        {
            return (T)Convert.ChangeType(
                sd.Info.CodeGenerationSettings.Extensions[name], 
                typeof(T).GenericTypeArguments.Length == 0 ? typeof(T) : typeof(T).GenericTypeArguments[0] // un-nullable
            );
        }
        catch
        {
            return default(T);
        }
    }

    protected override async Task<bool> ProcessInternal()
    {
        var files = await ListInputs();
        if (files.Length != 2)
        {
            throw new Exception($"Generator received incorrect number of inputs: ${files.Length} : {files.Aggregate("", (c,e)=> c+=","+e)}");
        }

        var sd = Singleton<ServiceDefinition>.Instance = SwaggerParser.Parse("", await ReadFile(files[0]));

        // get internal name
        var language = new[] {
            "CSharp",
            "Ruby",
            "NodeJS",
            "Python",
            "Go",
            "Java",
            "AzureResourceSchema",
            "JsonRpcClient" }
          .Where(x => x.ToLowerInvariant() == codeGenerator)
          .FirstOrDefault();

        if (language == null)
        {
            throw new Exception($"Language '{codeGenerator}' unknown.");
        }

        // build settings
        var altNamespace = (await GetValue<string[]>("input-file") ?? new[] { "" }).FirstOrDefault()?.Split('/').Last().Split('\\').Last().Split('.').First();

        new Settings
        {
            Namespace = await GetValue("namespace"),
            ClientName = GetXmsCodeGenSetting<string>(sd, "name") ?? await GetValue("override-client-name"),
            PayloadFlatteningThreshold = GetXmsCodeGenSetting<int?>(sd, "ft") ?? await GetValue<int?>("payload-flattening-threshold") ?? 0,
            AddCredentials = await GetValue<bool?>("add-credentials") ?? false,
        };
        var header = await GetValue("license-header");
        if (header != null)
        {
            Settings.Instance.Header = header;
        }
        Settings.Instance.CustomSettings.Add("InternalConstructors", GetXmsCodeGenSetting<bool?>(sd, "internalConstructors") ?? await GetValue<bool?>("use-internal-constructors") ?? false);
        Settings.Instance.CustomSettings.Add("SyncMethods", GetXmsCodeGenSetting<string>(sd, "syncMethods") ?? await GetValue("sync-methods") ?? "essential");
        Settings.Instance.CustomSettings.Add("UseDateTimeOffset", GetXmsCodeGenSetting<bool?>(sd, "useDateTimeOffset") ?? await GetValue<bool?>("use-datetimeoffset") ?? false);
        Settings.Instance.CustomSettings["ClientSideValidation"] = await GetValue<bool?>("client-side-validation") ?? false;
        if (codeGenerator == "ruby" || codeGenerator == "python")
        {
            // TODO: sort out matters here entirely instead of relying on Input being read somewhere...
            var inputFile = await GetValue<string[]>("input-file");
            Settings.Instance.Input = inputFile.FirstOrDefault();
            Settings.Instance.PackageName = await GetValue("package-name");
            Settings.Instance.PackageVersion = await GetValue("package-version");
        }

        // process
        var plugin = ExtensionsLoader.GetPlugin(
            (await GetValue<bool?>("azure-arm") ?? false ? "Azure." : "") +
            language +
            (await GetValue<bool?>("fluent") ?? false ? ".Fluent" : "") +
            (await GetValue<bool?>("testgen") ?? false ? ".TestGen" : ""));
        var modelAsJson = (await ReadFile(files[1])).EnsureYamlIsJson();

        using (plugin.Activate())
        {
            Settings.Instance.Namespace = Settings.Instance.Namespace ?? CodeNamer.Instance.GetNamespaceName(altNamespace);
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