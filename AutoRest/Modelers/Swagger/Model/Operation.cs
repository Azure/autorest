// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Globalization;
using System.Collections.Generic;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Modeler.Swagger.Model
{
    /// <summary>
    /// Describes a single API operation on a path.
    /// </summary>
    public class Operation : SwaggerBase
    {
        public Operation()
        {
            Consumes = new List<string>();
            Produces = new List<string>();
        }

        /// <summary>
        /// A list of tags for API documentation control.
        /// </summary>
        public IList<string> Tags { get; set; }

        /// <summary>
        /// A friendly serviceTypeName for the operation. The id MUST be unique among all 
        /// operations described in the API. Tools and libraries MAY use the 
        /// operation id to uniquely identify an operation.
        /// </summary>
        public string OperationId { get; set; }

        public string Summary { get; set; }

        public string Description { get; set; }

        /// <summary>
        /// Additional external documentation for this operation.
        /// </summary>
        public ExternalDoc ExternalDocs { get; set; }

        /// <summary>
        /// A list of MIME types the operation can consume.
        /// </summary>
        public IList<string> Consumes { get; set; }

        /// <summary>
        /// A list of MIME types the operation can produce. 
        /// </summary>
        public IList<string> Produces { get; set; }

        /// <summary>
        /// A list of parameters that are applicable for this operation. 
        /// If a parameter is already defined at the Path Item, the 
        /// new definition will override it, but can never remove it.
        /// </summary>
        public IList<SwaggerParameter> Parameters { get; set; }

        /// <summary>
        /// The list of possible responses as they are returned from executing this operation.
        /// </summary>
        public Dictionary<string, OperationResponse> Responses { get; set; }

        /// <summary>
        /// The transfer protocol for the operation. 
        /// </summary>
        public IList<TransferProtocolScheme> Schemes { get; set; }

        public bool Deprecated { get; set; }

        /// <summary>
        /// A declaration of which security schemes are applied for this operation. 
        /// The list of values describes alternative security schemes that can be used 
        /// (that is, there is a logical OR between the security requirements). 
        /// This definition overrides any declared top-level security. To remove a 
        /// top-level security declaration, an empty array can be used.
        /// </summary>
        public IList<Dictionary<string, List<string>>> Security { get; set; }

        /// <summary>
        /// Validate the Swagger object against a number of object-specific validation rules.
        /// </summary>
        /// <param name="validationErrors">A list of error messages, filled in during processing.</param>
        /// <returns>True if there are no validation errors, false otherwise.</returns>
        public override bool Validate(List<LogEntry> validationErrors)
        {
            var errorCount = validationErrors.Count;

            var errors = new List<LogEntry>();

            base.Validate(errors);

            errors.AddRange(Consumes
                .Where(input => !string.IsNullOrEmpty(input) && !input.Contains("json"))
                .Select(input => new LogEntry
                {
                    Severity = LogEntrySeverity.Error,
                    Message = string.Format("Currently, only JSON-based request payloads are supported, so '{0}' won't work.", input)
                }));

            errors.AddRange(Produces
                .Where(input => !string.IsNullOrEmpty(input) && !input.Contains("json"))
                .Select(input => new LogEntry
                {
                    Severity = LogEntrySeverity.Error,
                    Message = string.Format("Currently, only JSON-based request payloads are supported, so '{0}' won't work.", input)
                }));

            foreach (var param in Parameters)
            {
                param.Validate(errors);
            }

            if (Responses == null || Responses.Count == 0)
            {
                errors.Add(new LogEntry
                {
                    Severity = LogEntrySeverity.Error,
                    Message = string.Format(CultureInfo.InvariantCulture, "No response objects defined.")
                });
            }
            else
            {
                foreach (var response in Responses.Values)
                {
                    response.Validate(errors);
                }
            }

            if (ExternalDocs != null)
                ExternalDocs.Validate(errors);

            validationErrors.AddRange(errors.Select(e => new LogEntry
            {
                Severity = e.Severity,
                Message = OperationId + ": " + e.Message,
                Exception = e.Exception
            }));

            return validationErrors.Count == errorCount;
        }

        public override bool Compare(SwaggerBase priorVersion, ValidationContext context)
        {
            var priorOperation = priorVersion as Operation;

            if (priorOperation == null)
            {
                throw new ArgumentNullException("priorVersion");
            }

            var errorCount = context.ValidationErrors.Count;

            base.Compare(priorVersion, context);


            if (string.IsNullOrEmpty(OperationId))
            {
                context.LogError("Empty operationId in new version.");
            }
            else
            {
                if (!OperationId.Equals(priorOperation.OperationId))
                {
                    context.LogBreakingChange("The operation id has been changed. This will impact the generated code.");
                }
            }

            // Check that no parameters were removed or reordered, and compare them if it's not the case.

            foreach (var oldParam in priorOperation.Parameters)
            {
                SwaggerParameter newParam = Parameters.FirstOrDefault(p => p.Name != null && p.Name.Equals(oldParam.Name));

                if (newParam != null)
                {
                    context.PushTitle(context.Title + "/" + oldParam.Name);
                    newParam.Compare(oldParam, context);
                    context.PopTitle();
                }
                else if (oldParam.IsRequired)
                {
                    context.LogBreakingChange("A required parameter has been removed");
                }
            }

            // Check that no required parameters were added.

            foreach (var newParam in Parameters.Where(p => p.IsRequired))
            {
                SwaggerParameter oldParam = priorOperation.Parameters.FirstOrDefault(p => p.Name != null && p.Name.Equals(newParam.Name));

                if (oldParam == null)
                {
                    context.LogBreakingChange(string.Format("The new version adds a required parameter '{0}'.", newParam.Name));
                }
            }

            return context.ValidationErrors.Count == errorCount;
        }
    }
}