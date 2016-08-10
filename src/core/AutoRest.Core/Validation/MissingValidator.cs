// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Logging;

namespace AutoRest.Core.Validation
{
    /// <summary>
    /// This validator is applied by default to all string members,
    /// can be used to find out which properties are not being explicitly 
    /// validated
    /// </summary>
    public class MissingValidator : TypedRule<string>
    {
        /// <summary>
        /// Assumes that if this is being applied to a type, that it's not valid. 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        public override bool IsValid(string entity) => false;

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => "Missing Validator";

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Debug;
    }
}