// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using AutoRest.Core.Logging;
using Microsoft.Perks.JsonRPC;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.Core.Utilities;
using System.Text.RegularExpressions;
using AutoRest.Core.Logging;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using AutoRest.Swagger;
using AutoRest.Swagger.Validation.Core;

public class NewPlugin
{
  public IDisposable Start => NewContext;

  public Func<string, Task<string>> ReadFile;
  public Func<string, Task<string>> GetValue;
  public Action<Dictionary<string, string>, object> Message;
  public Action<string, string, string> WriteFile;
  public Func<Task<string[]>> ListInputs;

  private readonly Regex resPathPattern = new Regex(@"/providers/(?<providerNamespace>[^{/]+)/((?<resourceType>[^{/]+)/)?");
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
  public void AddMessageListener()
  {
    Logger.Instance.AddListener(
      new SignalingLogListener(Category.Debug, (message) =>
      {
        // cast the validation message
        var validationMessage = message as ValidationMessage;

        string path = validationMessage.Path.ObjectPath.Path
            .OfType<ObjectPathPartProperty>()
            .Select(p => p.Property)
            .SkipWhile(p => p != "paths")
            .Skip(1)
            .FirstOrDefault();
        var pathComponents = resPathPattern.Match(path ?? "");
        var pathComponentProviderNamespace = pathComponents.Groups["providerNamespace"];
        var pathComponentResourceType = pathComponents.Groups["resourceType"];

        // create the raw message
        var rawMessage = new Dictionary<string, string>() {
              { "type", validationMessage.Severity.ToString() },
              { "code",  validationMessage.Rule.GetType().Name},
              { "message" , validationMessage.Message },
              {"jsonref", validationMessage.Path.JsonReference },
              {"json-path",  validationMessage.Path.ReadablePath},
              {"id",validationMessage.Rule.Id },
              {"validationCategory",  validationMessage.Rule.ValidationCategory.ToString()},
              {"providerNamespace", pathComponentProviderNamespace.Success ? pathComponentProviderNamespace.Value : null },
              {"resourceType", pathComponentResourceType.Success ? pathComponentResourceType.Value : null}
        };

        // post it to the pipe
        Message(rawMessage, new object[0]);
      }
    ));
  }

}

public class AzureValidator : NewPlugin
{
  public AzureValidator(Connection connection, string sessionId) : base(connection, sessionId)
  {

  }
  public async Task<bool> Process()
  {
    try
    {
      using (Start)
      {
        AddMessageListener();

        var files = await ListInputs();
        if (files.Length != 1)
        {
          return false;
        }

        var content = await ReadFile(files[0]);
        var fs = new MemoryFileSystem();
        fs.VirtualStore.Add(files[0], new StringBuilder(content));

        var serviceDefinition = SwaggerParser.Load(files[0], fs);
        var validator = new RecursiveObjectValidator(PropertyNameResolver.JsonName);
        foreach (var validationEx in validator.GetValidationExceptions(new Uri(files[0], UriKind.RelativeOrAbsolute), serviceDefinition))
        {
          Logger.Instance.Log(validationEx);
        }
      }
    }
    catch
    {
      return false; // replace by more verbose feedback
    }

    return true;
  }
}