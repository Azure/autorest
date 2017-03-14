using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AutoRest.JsonRpc
{
    class PeekingBinaryReader : IDisposable
    {
        byte? lastByte;
        Stream input;

        public PeekingBinaryReader(Stream input)
        {
            this.lastByte = null;
            this.input = input;
        }

        public int ReadByte()
        {
            if (lastByte.HasValue)
            {
                var result = lastByte.Value;
                lastByte = null;
                return result;
            }
            return input.ReadByte();
        }

        public int PeekByte()
        {
            if (lastByte.HasValue)
            {
                return lastByte.Value;
            }
            var result = ReadByte();
            if (result != -1)
            {
                lastByte = (byte)result;
            }
            return result;
        }

        public async Task<byte[]> ReadBytesAsync(int count)
        {
            var buffer = new byte[count];
            var read = 0;
            if (count > 0 && lastByte.HasValue)
            {
                buffer[read++] = lastByte.Value;
                lastByte = null;
            }
            while (read < count)
            {
                read += await input.ReadAsync(buffer, read, count - read);
            }
            return buffer;
        }

        public string ReadAsciiLine()
        {
            var result = new StringBuilder();
            int c = ReadByte();
            while (c != '\r' && c != '\n' && c != -1)
            {
                result.Append((char)c);
                c = ReadByte();
            }
            if (c == '\r' && PeekByte() == '\n')
            {
                ReadByte();
            }
            if (c == -1 && result.Length == 0)
            {
                return null;
            }
            return result.ToString();
        }

        public void Dispose()
        {
            input.Dispose();
        }
    }
}
