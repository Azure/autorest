// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Diagnostics.CodeAnalysis;

namespace AutoRest.Core.Model
{
    /// <summary>
    /// Defines collection formats.
    /// </summary>
    public enum CollectionFormat
    {
        /// <summary>
        /// Default unspecified CollectionFormat.
        /// </summary>
        None,

        /// <summary>
        /// Comma separated values foo,bar
        /// </summary>
        Csv,

        /// <summary>
        /// Space separated values foo bar.
        /// </summary>
        [SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Ssv", Justification = "Valid format.")]
        Ssv,

        /// <summary>
        /// Tab separated values foo\tbar.
        /// </summary>
        [SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Tsv", Justification = "Valid format.")]
        Tsv,

        /// <summary>
        /// Pipe separated values foo|bar.
        /// </summary>
        Pipes,

        /// <summary>
        /// Corresponds to multiple parameter instances instead of multiple values for
        /// a single instance foo=bar&amp;foo=baz. This is valid only for parameters in
        /// "query" or "formData".
        /// </summary>
        [SuppressMessage("Microsoft.Naming", "CA1704:IdentifiersShouldBeSpelledCorrectly", MessageId = "Multi", Justification = "Valid format.")]
        Multi
    }
}