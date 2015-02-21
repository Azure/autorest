using System;
using System.Net;
using AutoRest02;

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

            Console.WriteLine("Enter to exit.");
            Console.ReadLine();
        }
    }
}
