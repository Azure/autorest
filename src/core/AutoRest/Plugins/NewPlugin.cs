// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Perks.JsonRPC;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.Core.Logging;
using System.Linq;

static class Channel
{
    public static readonly string Information = "information";
    public static readonly string Warning = "warning";
    public static readonly string Error = "error";
    public static readonly string Debug = "debug";
    public static readonly string Verbose = "verbose";
    public static readonly string Fatal = "fatal";
}
// KEEP IN SYNC with message.ts
public class SmartPosition
{
  public object[] path { get; set; }
}

public class SourceLocation
{
  public string document { get; set; }
  public SmartPosition Position { get; set; }
}

public class Message
{
  public string Channel { get; set; }
  public object Details { get; set; }
  public string Text { get; set; }
  public string[] Key { get; set; }
  public SourceLocation[] Source { get; set; }
}

class JsonRpcLogListener : ILogListener
{
    private Action<Message> SendMessage;

    public JsonRpcLogListener(Action<Message> sendMessage)
    {
        SendMessage = sendMessage;
    }

    private string GetChannel(Category cat)
    {
        switch (cat)
        {
            case Category.Debug: return Channel.Debug;
            case Category.Error: return Channel.Error;
            case Category.Fatal: return Channel.Fatal;
            case Category.Info: return Channel.Information;
            case Category.Warning: return Channel.Warning;
        }
        return null;
    }

    private SourceLocation[] GetSourceLocations(FileObjectPath path)
    {
        if (path == null)
        {
            return new SourceLocation[0];
        }
        return new[]
        {
            new SourceLocation
            {
                document = path.FilePath?.ToString(),
                Position = new SmartPosition
                {
                    path = path.ObjectPath?.Path.Select(part => part.RawPath).ToArray() ?? new object[0]
                }
            }
        };
    }

    public void Log(LogMessage m)
    {
        var message = new Message();
        SendMessage(new Message
        {
            Text = m.Message,
            Source = GetSourceLocations(m.Path),
            Channel = GetChannel(m.Severity)
        });
    }
}

public abstract class NewPlugin :  AutoRest.Core.IHost
{
    private IDisposable Start => NewContext;

    public Task<string> ReadFile(string filename) => _connection.Request<string>("ReadFile", _sessionId, filename);
    public Task<T> GetValue<T>(string key) => _connection.Request<T>("GetValue", _sessionId, key);
    public Task<string> GetValue(string key) => GetValue<string>(key);
    public Task<string[]> ListInputs() => _connection.Request<string[]>("ListInputs", _sessionId);

    public void Message(Message message) => _connection.Notify("Message", _sessionId, message);
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
                Logger.Instance.AddListener(new JsonRpcLogListener(Message));
                return await ProcessInternal();
            }
        }
        catch (Exception e)
        {
            Message(new Message
            {
                Channel = "fatal",
                Text = e.ToString()
            });
            return false;
        }
    }

    protected abstract Task<bool> ProcessInternal();
}