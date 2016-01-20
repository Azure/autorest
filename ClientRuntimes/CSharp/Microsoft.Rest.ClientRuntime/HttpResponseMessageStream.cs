// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace Microsoft.Rest
{
    /// <summary>
    /// Wrapper class for HttpResponseMessage stream. Ensures that underlying HttpResponseMessage
    /// gets disposed when the stream is disposed.
    /// </summary>
    public class HttpResponseMessageStream : Stream, IDisposable
    {
        /// <summary>
        /// Indicates whether the HttpOperationResponse has been disposed. 
        /// </summary>
        private bool _disposed;

        /// <summary>
        /// Underlying HttpResponseMessage.
        /// </summary>
        private HttpResponseMessage _responseMessage;

        /// <summary>
        /// Underlying Stream.
        /// </summary>
        private Stream _stream;

        /// <summary>
        /// Initializes a new instance of HttpMessageStream from HttpResponseMessage and a Stream.
        /// </summary>
        /// <param name="response">Associated HttpResponseMessage</param>
        /// <param name="stream">Associated Stream</param>
        public HttpResponseMessageStream(HttpResponseMessage response, Stream stream) : base()
        {
            if (response == null)
            {
                throw new ArgumentNullException("response");
            }
            if (stream == null)
            {
                throw new ArgumentNullException("stream");
            }

            _responseMessage = response;
            _stream = stream;
        }

        /// <summary>
        /// Gets a value indicating whether the current stream supports reading.
        /// </summary>
        public override bool CanRead
        {
            get
            {
                return _stream.CanRead;
            }
        }

        /// <summary>
        /// Gets a value indicating whether the current stream supports seeking.
        /// </summary>
        public override bool CanSeek
        {
            get
            {
                return _stream.CanSeek;
            }
        }

        /// <summary>
        /// Gets a value indicating whether the current stream supports writing.
        /// </summary>
        public override bool CanWrite
        {
            get
            {
                return _stream.CanWrite;
            }
        }

        /// <summary>
        /// Gets the length in bytes of the stream.
        /// </summary>
        public override long Length
        {
            get
            {
                return _stream.Length;
            }
        }

        /// <summary>
        /// Gets or sets the position within the current stream.
        /// </summary>
        public override long Position
        {
            get
            {
                return _stream.Position;
            }

            set
            {
                _stream.Position = value;
            }
        }

        /// <summary>
        /// Clears all buffers for this stream and causes any buffered data to be written 
        /// to the underlying device.
        /// </summary>
        public override void Flush()
        {
            _stream.Flush();
        }

        /// <summary>
        /// Reads a sequence of bytes from the current stream and advances the position 
        /// within the stream by the number of bytes read.
        /// </summary>
        /// <param name="buffer">An array of bytes. When this method returns, the buffer contains the specified
        /// byte array with the values between offset and (offset + count - 1) replaced by
        /// the bytes read from the current source.</param>
        /// <param name="offset">The zero-based byte offset in buffer at which to begin storing the data read
        /// from the current stream.</param>
        /// <param name="count">The maximum number of bytes to be read from the current stream.</param>
        /// <returns>The total number of bytes read into the buffer. This can be less than the number
        /// of bytes requested if that many bytes are not currently available, or zero (0)
        /// if the end of the stream has been reached.</returns>
        public override int Read(byte[] buffer, int offset, int count)
        {
            return _stream.Read(buffer, offset, count);
        }

        /// <summary>
        /// Sets the position within the current stream.
        /// </summary>
        /// <param name="offset">A byte offset relative to the origin parameter.</param>
        /// <param name="origin">A value of type System.IO.SeekOrigin indicating the reference point used to obtain
        /// the new position.</param>
        /// <returns>The new position within the current stream.</returns>
        public override long Seek(long offset, SeekOrigin origin)
        {
            return _stream.Seek(offset, origin);
        }

        /// <summary>
        /// Sets the length of the current stream.
        /// </summary>
        /// <param name="value">The desired length of the current stream in bytes.</param>
        public override void SetLength(long value)
        {
            _stream.SetLength(value);
        }

        /// <summary>
        /// When overridden in a derived class, writes a sequence of bytes to the current
        /// stream and advances the current position within this stream by the number of
        /// bytes written.
        /// </summary>
        /// <param name="buffer">An array of bytes. This method copies count bytes from buffer to the current
        /// stream.</param>
        /// <param name="offset">The zero-based byte offset in buffer at which to begin copying bytes to the current
        /// stream.</param>
        /// <param name="count">The number of bytes to be written to the current stream.</param>
        public override void Write(byte[] buffer, int offset, int count)
        {
            _stream.Write(buffer, offset, count);
        }

        /// <summary>
        /// Releases the unmanaged resources used by the System.IO.Stream as well as underlying
        /// HttpResponseMessage.
        /// </summary>
        /// <param name="disposing"></param>
        protected override void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                _disposed = true;

                _responseMessage.Dispose();
                _stream.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
