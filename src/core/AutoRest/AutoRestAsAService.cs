// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoRest.Core.Logging;
using Microsoft.Perks.JsonRPC;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.Core.Utilities;

namespace AutoRest
{

  public class AutoRestAsAsService
  {
    private Connection connection;

    public async Task<int> Run()
    {
      connection = new Connection(Console.Out, Console.OpenStandardInput());
      // connection.OnDebug += (t) => Console.Error.WriteLine(t);

      connection.Dispatch<IEnumerable<string>>(nameof(GetPluginNames), GetPluginNames);
      connection.Dispatch<string, string, bool>(nameof(Process), Process);
      connection.DispatchNotification("Shutdown", connection.Stop);

      // wait for somethign to do.
      await connection;

      Console.Error.WriteLine("Shutting Down");
      return 0;
    }

    public async Task<IEnumerable<string>> GetPluginNames()
    {
      return new[] { "azure-validator", "modeler", "csharp", "ruby", "nodejs", "python", "go", "java", "azureresourceschema", "csharp-simplifier", "jsonrpcclient" };
    }

    public async Task<bool> Process(string plugin, string sessionId)
    {
      switch (plugin)
      {
        case "modeler":
          return await new Modeler(connection, sessionId).Process();
        case "csharp":
        case "ruby":
        case "nodejs":
        case "python":
        case "go":
        case "java":
        case "azureresourceschema":
        case "jsonrpcclient":
          return await new Generator(plugin, connection, sessionId).Process();
        case "csharp-simplifier":
          return await new CSharpSimplifier(connection, sessionId).Process();
      }
      return false;
    }
  }

}