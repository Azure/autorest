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
      connection = new Connection(Console.Out, Console.In);
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
      return new[] { nameof(AzureValidator), nameof(Modeler), nameof(Generator) };
    }

    public async Task<bool> Process(string plugin, string sessionId)
    {
      switch (plugin)
      {
        case nameof(AzureValidator):
          return await new AzureValidator(connection, sessionId).Process();
        case nameof(Modeler):
          return await new Modeler(connection, sessionId).Process();
        case nameof(Generator):
          return await new Generator(connection, sessionId).Process();
      }
      return false;
      /*
      Console.Error.WriteLine("Getting some values");
      var v = await GetValue(sessionId, "key");
      Console.Error.WriteLine($"Value was : '{v}'");

      var f = await ReadFile(sessionId, "filename");
      Console.Error.WriteLine($"File was : '{f}'");

      WriteFile(sessionId, "somefile.txt", "this is the file content", null);
      Message(sessionId, "this is some details","nothing for you");

      f = await ReadFile(sessionId, "lastfile");
      Console.Error.WriteLine("Done Process on client");
      return false;
       */
    }
  }

}