using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Strategies
{
    public class LibFolderCreator
    {
        private readonly string _libPath;

        public LibFolderCreator(string libPath)
        {
            _libPath = libPath;
        }

        public async Task ExecuteAsync()
        {
            if (!Directory.Exists(_libPath))
            {
                Directory.CreateDirectory(_libPath);
            }

            Func<string, string> parent = path => Directory.GetParent(path).FullName;
            var currentPath = Directory.GetCurrentDirectory();

            var dllPath = Directory.GetFiles(currentPath, "AutoRest.CSharp.LoadBalanced.Json.dll", SearchOption.AllDirectories).FirstOrDefault();

            if (dllPath != null)
            {
                var file = new FileInfo(dllPath);
                var destFilePath = Path.Combine(_libPath, file.Name);

                if (File.Exists(destFilePath))
                {
                    File.Delete(destFilePath);
                }

                File.Copy(file.FullName, destFilePath);
            }
        }
    }
}
