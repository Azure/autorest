// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Logging;
using Microsoft.Perks.JsonRPC;
using AutoRest.Core.Utilities;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Swagger;
using AutoRest.Swagger.Validation.Core;
using System.Threading.Tasks;
using System;

public class AzureValidator : NewPlugin
{
  public AzureValidator(Connection connection, string sessionId) : base(connection, sessionId)
  { }

  private readonly Regex resPathPattern = new Regex(@"/providers/(?<providerNamespace>[^{/]+)/((?<resourceType>[^{/]+)/)?");

  private void LogValidationMessage(ValidationMessage validationMessage)
  {
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

  protected override async Task<bool> ProcessInternal()
  {
    var files = await ListInputs();
    if (files.Length != 1)
    {
      return false;
    }

    var content = await ReadFile(files[0]);
    var fs = new MemoryFileSystem();
    fs.WriteAllText(files[0], content);

    var serviceDefinition = SwaggerParser.Load(files[0], fs);
    var validator = new RecursiveObjectValidator(PropertyNameResolver.JsonName);
    foreach (ValidationMessage validationEx in validator.GetValidationExceptions(new Uri(files[0], UriKind.RelativeOrAbsolute), serviceDefinition))
    {
      LogValidationMessage(validationEx);
    }

    return true;
  }
}