using System;
using Sample01;

namespace SampleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            var client01 = new Client01();
            var salutation = client01.GetGreeting();
            Console.WriteLine(salutation);
            Console.WriteLine("Any key to exit.");
            Console.ReadKey();
        }
    }
}
