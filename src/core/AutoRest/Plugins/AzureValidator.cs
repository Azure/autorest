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
using AutoRest.Swagger.Model;

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
        var rawMessageDetails = new Dictionary<string, string>() {
        { "type", validationMessage.Severity.ToString() },
        { "code", validationMessage.Rule.GetType().Name },
        { "message", validationMessage.Message },
        { "id", validationMessage.Rule.Id },
        { "validationCategory", validationMessage.Rule.ValidationCategory.ToString() },
        { "providerNamespace", pathComponentProviderNamespace.Success ? pathComponentProviderNamespace.Value : null },
        { "resourceType", pathComponentResourceType.Success ? pathComponentResourceType.Value : null }
    };

        // post it to the pipe
        Message(new Message
        {
            Text = validationMessage.Message,
            Channel = validationMessage.Severity.ToString().ToLowerInvariant(),
            Details = rawMessageDetails,
            Key = new string[]
            {
            validationMessage.Rule.GetType().Name,
            validationMessage.Rule.Id,
            validationMessage.Rule.ValidationCategory.ToString()
            },
            Source = new[]
            {
            new SourceLocation
            {
                document = validationMessage.Path.FilePath.ToString(),
                Position = new SmartPosition
                {
                    path = validationMessage.Path.ObjectPath.Path.Select(x => x.RawPath).ToArray()
                }
            }
        }
        }, new object[0]);
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
        var metadata = new ServiceDefinitionMetadata
            {
                OpenApiDocumentType = (ServiceDefinitionDocumentType)Enum.Parse(typeof(ServiceDefinitionDocumentType), (await GetValue("openapi-type"))?.ToString().ToUpper() ?? ServiceDefinitionDocumentType.Default.ToString()),
                MergeState = await GetValue<bool?>("is-individual-swagger") == true ? ServiceDefinitionMergeState.Before : ServiceDefinitionMergeState.After
            };
        foreach (ValidationMessage validationEx in validator.GetValidationExceptions(new Uri(files[0], UriKind.RelativeOrAbsolute), serviceDefinition, metadata))
        {
            LogValidationMessage(validationEx);
        }

        return true;
    }
}