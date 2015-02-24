using System;
using AutoRest02;
using Microsoft.Rest;

namespace SampleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            var client02 = new Client02();
            try
            {
                client02.GetGreeting();
            }
            catch (HttpOperationException e)
            {
                Console.WriteLine("inappropriate greeting");
                Console.WriteLine(e.Message);
            }

            Console.WriteLine("Any key to exit.");
            Console.ReadLine();
        }
    }
}
