// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Perks.JsonRPC;
using Newtonsoft.Json;

namespace AutoRest
{

  public class AutoRestAsAsService {
    public delegate string ReadFileDelegate(string sessionId, string filename );
    public Func<string, string,Task<string>> ReadFile;
    public Func<string,string,Task<string>> GetValue;
    public Action<string,string,string> Message;
    public Action<string,string,string,string> WriteFile;


    public async Task<int> Run() {
       var connection = new Connection(Console.Out,Console.In);

       // connection.OnDebug += (t) => Console.Error.WriteLine(t);

       connection.Dispatch<IEnumerable<string>>(nameof(GetPluginNames), GetPluginNames );
       connection.Dispatch<string,string,bool>(nameof(Process), Process );
       connection.DispatchNotification("Shutdown", connection.Stop);

       // remote requests
       ReadFile = async (sessionId,filename)=> await connection.Request<string>("ReadFile",sessionId,filename);
       GetValue = async (sessionId,key)=>  await connection.Request<string>("GetValue",sessionId,key);
       
       // remote notifications
       Message = (session,details,sourcemap) => connection.Notify("Message",session,details,sourcemap);
       WriteFile = (session,filename,content,sourcemap) => connection.Notify("WriteFile",session,filename,content,sourcemap);

       // wait for somethign to do.
       await connection;

       Console.Error.WriteLine("Shutting Down");
       return 0;
    }

    public async Task<IEnumerable<string>> GetPluginNames() {
       return new [] { "Modeler" };
    }

    public async Task<bool> Process(string plugin, string sessionId) {
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
    }
  }

}