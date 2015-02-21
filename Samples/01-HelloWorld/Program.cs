using System;
using System.Net;
using AutoRest01;

namespace SampleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(new Client01().GetGreeting().Body);

            var client01 = new Client01();
            var result = client01.GetGreeting();
            var salutation = result.Body;
            Console.WriteLine(salutation);
            Console.WriteLine("Enter to exit.");
            Console.ReadLine();
        }
    }
}
