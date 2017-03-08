
using System.IO;
using System.Threading.Tasks;

namespace Microsoft.Perks.JsonRPC
{
    public class PeekingTextReader : TextReader {
        private char[] _peekAhead = new char[1]; 

        private bool hasChar = false;
       
        public override string ReadLine() => 
            ReadLineAsync().Result;
        public override int Read(char[] buffer, int start, int count) => 
            ReadAsync( buffer, start, count).Result;
        public override string ReadToEnd() => 
            ReadToEndAsync().Result;

        public override int Read() {
            if( !hasChar ) {
                PeekAsync().Wait();
            }
            if( !hasChar ) {
                throw new EndOfStreamException("Unable to read from stream");
            }
            hasChar = false;
            return _peekAhead[0];
        }
      
        public override async Task<int> ReadAsync(char[] buffer, int index, int count) {
            if( hasChar ) {
                //peeked. frontload the first char
                hasChar = false;
                buffer[index++] = _peekAhead[0];
                return await _reader.ReadAsync(buffer, index, count-1) +1;
            }
            // haven't peeked. 
            return await _reader.ReadAsync(buffer, index, count);
        }

        public override async Task<string> ReadLineAsync() {
            if( hasChar ) {
                //peeked. frontload the first char
                hasChar = false;
                return  _peekAhead[0] + await _reader.ReadLineAsync();
            }
            return await _reader.ReadLineAsync();
        }
        public override async Task<string> ReadToEndAsync() {
            if( hasChar ) {
                //peeked. frontload the first char
                hasChar = false;
                return  _peekAhead[0] + await _reader.ReadToEndAsync();
            }
            return await _reader.ReadToEndAsync();
        }

        public async Task<char?> PeekAsync() {
            if( !hasChar ) {
                hasChar = await _reader.ReadAsync(_peekAhead, 0, 1) > 0;
            }
            return hasChar ? (char?) _peekAhead[0]:null;
        }

        private TextReader _reader;
        public PeekingTextReader(TextReader reader) {
            _reader = reader;
        }
        protected override void Dispose(bool disposing) {
            base.Dispose(disposing);
            if( disposing ) {
                _reader?.Dispose();
                _reader = null;
            }
        }
    }
}