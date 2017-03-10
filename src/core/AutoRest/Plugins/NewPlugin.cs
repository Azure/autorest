// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoRest.Core.Logging;
using Microsoft.Perks.JsonRPC;
using static AutoRest.Core.Utilities.DependencyInjection;
using System.Text.RegularExpressions;
using System.Linq;
using AutoRest.Core.Validation;

public abstract class NewPlugin
{
  private IDisposable Start => NewContext;

  public Func<string, Task<string>> ReadFile;
  public Func<string, Task<string>> GetValue;
  public Action<Dictionary<string, string>, object> Message;
  public Action<string, string, object> WriteFile;
  public Func<Task<string[]>> ListInputs;

  protected string _sessionId;
  private Connection _connection;

  public NewPlugin(Connection connection, string sessionId)
  {
    _sessionId = sessionId;
    _connection = connection;

    // remote requests
    ReadFile = async (filename) => await connection.Request<string>("ReadFile", sessionId, filename);
    GetValue = async (key) => await connection.Request<string>("GetValue", sessionId, key);
    ListInputs = async () => await connection.Request<string[]>("ListInputs", sessionId);

    // remote notifications
    Message = (details, sourcemap) => connection.Notify("Message", sessionId, details, sourcemap);
    WriteFile = (filename, content, sourcemap) => connection.Notify("WriteFile", sessionId, filename, content, sourcemap);
  }
    
  public async Task<bool> Process()
  {
    try
    {
      using (Start)
      {
        return await ProcessInternal();
      }
    }
    catch (Exception e)
    {
      Message(new Dictionary<string, string>
      {
          { "channel", "FATAL" },
          { "message", e.ToString() }
      }, null);
      return false;
    }
  }

  protected abstract Task<bool> ProcessInternal();
}
