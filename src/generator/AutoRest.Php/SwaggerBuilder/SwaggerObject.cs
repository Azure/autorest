using System.Collections.Generic;
using AutoRest.Php.JsonBuilder;
using AutoRest.Core.Model;
using System;

namespace AutoRest.Php.SwaggerBuilder
{
    public sealed class SwaggerObject : JsonBuilder.Object
    {
        public string Host { get; }

        public Object<SchemaObject> Definitions { get; }

        public Object<Object<OperationObject>> Paths { get; }

        public SwaggerObject(
            string host,
            string basePath,
            Object<Object<OperationObject>> paths,
            Object<SchemaObject> definitions)
        {
            Host = host;
            Definitions = definitions;
            Paths = paths;
        }

        public static SwaggerObject Create(CodeModel codeModel)
        {
            var url = new Uri(codeModel.BaseUrl);
            return new SwaggerObject(
                host: url.Host,
                basePath: url.LocalPath,
                paths: PathsObject.Create(codeModel.Methods),
                definitions: DefinitionsObject.Create(codeModel.ModelTypes));
        }

        public override IEnumerable<JsonBuilder.Property> GetProperties()
        {
            yield return Json.Property("host", Host);
            yield return Json.Property("paths", Paths);
            yield return Json.Property("definitions", Definitions);
        }
    }
}
