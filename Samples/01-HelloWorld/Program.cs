using System;
using AutoRest01;

namespace SampleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            var client01 = new Client01();
            var result = client01.GetGreeting();
            var salutation = result.Body;
            Console.WriteLine(salutation);
            Console.WriteLine("Any key to exit.");
            Console.ReadLine();
        }
    }
}
