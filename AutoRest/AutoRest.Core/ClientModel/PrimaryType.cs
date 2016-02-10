// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest.Generator.ClientModel
{
    /// <summary>
    /// Defines known model type.
    /// </summary>
    public abstract class PrimaryType : IType
    {
        /// <summary>
        /// Defines object model type.
        /// </summary>
        public class Object : PrimaryType
        {

        }

        /// <summary>
        /// Defines int model type.
        /// </summary>
        public class Int : PrimaryType
        {

        }

        /// <summary>
        /// Defines long model type.
        /// </summary>
        public class Long : PrimaryType
        {

        }

        /// <summary>
        /// Defines double model type.
        /// </summary>
        public class Double : PrimaryType
        {

        }

        /// <summary>
        /// Defines decimal model type.
        /// </summary>
        public class Decimal : PrimaryType
        {

        }

        /// <summary>
        /// Defines string model type.
        /// </summary>
        public class String : PrimaryType
        {

        }

        /// <summary>
        /// Defines byte array model type.
        /// </summary>
        public class ByteArray : PrimaryType
        {

        }

        /// <summary>
        /// Defines time span model type.
        /// </summary>
        public class TimeSpan : PrimaryType
        {

        }

        /// <summary>
        /// Defines date model type.
        /// </summary>
        public class Date : PrimaryType
        {

        }

        /// <summary>
        /// Defines date time model type.
        /// </summary>
        public class DateTime : PrimaryType
        {

        }

        /// <summary>
        /// Defines date time RFC1123 formatted model type.
        /// </summary>
        public class DateTimeRfc1123 : PrimaryType
        {

        }

        /// <summary>
        /// Defines stream model type.
        /// </summary>
        public class Stream : PrimaryType
        {

        }

        /// <summary>
        /// Defines boolean model type.
        /// </summary>
        public class Boolean : PrimaryType
        {

        }

        /// <summary>
        /// Defines credentials model type.
        /// </summary>
        public class Credentials : PrimaryType
        {

        }

        protected PrimaryType()
        {
            Name = this.GetType().Name;
        }

        /// <summary>
        /// Gets or sets the model type name on the wire.
        /// </summary>
        public string SerializedName { get; set; }

        /// <summary>
        /// Gets or sets the model type name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Returns a string representation of the PrimaryType object.
        /// </summary>
        /// <returns>
        /// A string representation of the PrimaryType object.
        /// </returns>
        public override string ToString()
        {
            return Name;
        }        
    }
}
