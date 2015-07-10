using System;
using Sample02;
using Microsoft.Rest;
using Sample02.Models;

namespace SampleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            var client02 = new Client02();
            try
            {
                Greeting greeting = client02.GetGreeting();
                Console.WriteLine(greeting.Salutation);
            }
            catch (HttpOperationException e)
            {
                Console.WriteLine("inappropriate greeting");
                Console.WriteLine(e.Message);
            }

            Console.WriteLine("Any key to exit.");
            Console.ReadKey();
        }
    }
}
