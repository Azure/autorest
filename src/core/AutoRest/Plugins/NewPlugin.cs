// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Perks.JsonRPC;
using static AutoRest.Core.Utilities.DependencyInjection;

static class Channel
{
    public static readonly string Information = "information";
    public static readonly string Warning = "warning";
    public static readonly string Error = "error";
    public static readonly string Debug = "debug";
    public static readonly string Verbose = "verbose";
    public static readonly string Fatal = "fatal";
}

public class Message
{
  public string Channel { get; set; }
  public object Details { get; set; }
  public string Text { get; set; }
}

public abstract class NewPlugin
{
  private IDisposable Start => NewContext;

  public Task<string> ReadFile(string filename) => _connection.Request<string>("ReadFile", _sessionId, filename);
  public Task<T> GetValue<T>(string key) => _connection.Request<T>("GetValue", _sessionId, key);
  public Task<string> GetValue(string key) => GetValue<string>(key);
  public Task<string[]> ListInputs() => _connection.Request<string[]>("ListInputs", _sessionId);

  public void Message(Message message, object sourcemap) => _connection.Notify("Message", _sessionId, message, sourcemap);
  public void WriteFile(string filename, string content, object sourcemap) => _connection.Notify("WriteFile", _sessionId, filename, content, sourcemap);

  protected string _sessionId;
  private Connection _connection;

  public NewPlugin(Connection connection, string sessionId)
  {
    _sessionId = sessionId;
    _connection = connection;
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
      Message(new Message
      {
          Channel = "fatal",
          Text = e.ToString()
      }, null);
      return false;
    }
  }

  protected abstract Task<bool> ProcessInternal();
}
