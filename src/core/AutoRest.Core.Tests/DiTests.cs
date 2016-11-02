// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Threading;
using System.Threading.Tasks;
using AutoRest.Core.Utilities;
using Xunit;
using Xunit.Abstractions;
using Xunit.Sdk;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core.Tests
{
    internal class SampleClass
    {
        // This is marked as Protected to demonstrate a way
        // to have a base class that shouldn't be directly
        // instantiated unless used via the Factory.
        protected SampleClass()
        {

        }
        public string Name { get { return "MyName"; } }

        public virtual string RealName { get { return "SampleClass RealName"; } }
        public string YourName { get; set; }
    }

    internal class ChildClass : SampleClass
    {
        public override string RealName { get { return "ChildClass RealName"; } }
    }

    internal class ThirdClass : SampleClass
    {
        public string SomeName { get; set; }

        public ThirdClass(string someName)
        {
            SomeName = someName;
        }
    }

    internal enum Something
    {
        One,
        Two,
        Three
    }

    internal class FourthClass : SampleClass
    {
        public Something Something { get; set; }
        public FourthClass(Something something)
        {
            Something = something;
        }
    }


    internal class FifthClass : SampleClass
    {
        public int Something { get; set; }
        public FifthClass(int something)
        {
            Something = something;
        }
    }

    internal class JustOneString
    {
        public string Text { get; set; }
    }

    public class DiTests
    {
        private ITestOutputHelper _output;
        public DiTests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public void TestBasicFactory()
        {
            // Even if we don't setup a factory first,
            // we can create objects and it will fall back to 
            // using the class itself.
            var sc = New<SampleClass>();

            // fyi: that creates an anonymous context that doesn't get disposed
            // until the process ends.

            // verify that we created an object
            Assert.NotNull(sc);

            Assert.Equal("MyName", sc.Name);
            Assert.Equal("SampleClass RealName", sc.RealName);
        }

        [Fact]
        public void TestBasicFactory2()
        {
            // a more appropriate way is to create an empty context first.
            // and explicitly activating it. this will make sure that it 
            // gets cleaned up.
            using (new Context().Activate())
            {
                // Even if we don't setup a factory first,
                // we can create objects and it will fall back to 
                // using the class itself.
                var sc = New<SampleClass>();

                // fyi: that creates an anonymous context that doesn't get disposed
                // until the process ends.

                // verify that we created an object
                Assert.NotNull(sc);

                Assert.Equal("MyName", sc.Name);
                Assert.Equal("SampleClass RealName", sc.RealName);
            }
        }

        [Fact]
        public void TestFactoryWithEasyOverride()
        {
            // create a context with a single override and activate it.
            using (new Context
            {
                new Factory<SampleClass, ChildClass>()
            }.Activate())
            {
                var sc = New<SampleClass>();

                // verify that we created an object
                Assert.NotNull(sc);

                Assert.Equal("MyName", sc.Name);
                Assert.Equal("ChildClass RealName", sc.RealName);
            }
        }

        [Fact]
        public void TestFactoryWithEasyInitializer()
        {
            // start from scratch
            using (new Context
            {
                new Factory<SampleClass, ChildClass>()
            }.Activate())
            {

                // an object initializer can be specified as the last parameter
                // (must be an anonymous object!)
                var sc = New<SampleClass>(new
                {
                    YourName = "Garrett"
                });

                // verify that we created an object
                Assert.NotNull(sc);

                Assert.Equal("MyName", sc.Name);
                Assert.Equal("ChildClass RealName", sc.RealName);
                Assert.Equal("Garrett", sc.YourName);
            }
        }

        [Fact]
        public void TestFactoryWithCustomConstructor()
        {
            // start from scratch
            using (new Context
            {
                new Factory<SampleClass>
                {
                    // you can initialize the Factory with a list 
                    // of delegates that will be used as constructors
                    (string yourName) => new ChildClass
                    {
                        YourName = yourName
                    }
                }
            }.Activate())
            {
                // Should use the custom constructor.
                var sc = New<SampleClass>("Garrett");

                // verify that we created an object
                Assert.NotNull(sc);

                Assert.Equal("Garrett", sc.YourName);
            }
        }

        [Fact]
        public async void TestContextsAcrossTasks()
        {
            await AcrossContexts();
        }

        public async Task AcrossContexts()
        {
            // create a context
            using (new Context { new Factory<JustOneString> { () => new JustOneString {Text = "Base"} } }.Activate())
            {
                // should get back an instance that uses the right constructor
                Assert.Equal("Base", New<JustOneString>().Text);

                // now, start a task in another thread
                var t = Task.Factory.StartNew(() =>
                {
                    // until we make our own context, we should be able to use the parent.
                    Assert.Equal("Base", New<JustOneString>().Text);

                    // create our own context
                    using (new Context {new Factory<JustOneString> {() => new JustOneString {Text = "Task1"}}}.Activate())
                    {
                        Assert.Equal("Task1", New<JustOneString>().Text);
                        Task.Delay(1000).Wait();

                        // again, just to make sure that we didn't get 
                        // confused with another task.
                        Assert.Equal("Task1", New<JustOneString>().Text);
                    }

                    // back in the parent context, right?
                    // (yet still in our task)
                    Assert.Equal("Base", New<JustOneString>().Text);
                });

                // small pause
                await Task.Delay(100);

                // nothing should have changed for us here.
                Assert.Equal("Base", New<JustOneString>().Text);

                var t2 = Task.Factory.StartNew(() =>
                {
                    // until we make our own context, we should be able to use the parent.
                    Assert.Equal("Base", New<JustOneString>().Text);

                    // create our own context
                    using ( new Context { new Factory<JustOneString> { () => new JustOneString { Text = "Task2" } } }.Activate())
                    {
                        Assert.Equal("Task2", New<JustOneString>().Text);
                        Task.Delay(500).Wait();

                        // again, just to make sure that we didn't get 
                        // confused with another task.
                        Assert.Equal("Task2", New<JustOneString>().Text);
                    }
                });

                // another small pause
                await Task.Delay(100);
                // still nothing should have changed for us here.
                Assert.Equal("Base", New<JustOneString>().Text);

                await t;
                // still nothing should have changed for us here.
                Assert.Equal("Base", New<JustOneString>().Text);

                await t2;
                // still nothing should have changed for us here.
                Assert.Equal("Base", New<JustOneString>().Text);
                
            }
        }

        [Fact]
        public void TestFactoryForMissingConstructor()
        {
            // create a private context and activate it.
            using (new Context
            {
                // only supply a constructor that takes a parameter
                new Factory<SampleClass>
                {
                    (string yourName) => new ChildClass
                    {
                        YourName = yourName
                    }
                }
            }.Activate())
            {
                // Should not find the empty constructor this time.
                Assert.ThrowsAny<Exception>(() => New<SampleClass>());
            }
        }

        [Fact]
        public void TestFactoryWithMoreCustomConstructors()
        {
            // start from scratch, override the global context.
            using (new Context
            {
                new Factory<SampleClass, ThirdClass>
                {
                    // add another two-parameter constructor
                    (string someName, string yourName) => new ThirdClass(someName) {YourName = yourName}
                }
            }.Activate())
            {
                // Should use the custom constructor.
                var sc = New<SampleClass>("Garrett");

                // verify that we created an object
                Assert.NotNull(sc);

                // this should be null
                Assert.Null(sc.YourName);

                // our ThirdClass property should be set tho'
                Assert.Equal("Garrett", (sc as ThirdClass)?.SomeName);

                // try and create one with the two-parameter constructor
                sc = New<SampleClass>("Garrett", "Serack");

                // verify that we created an object
                Assert.NotNull(sc);

                // this should be set this time
                Assert.Equal("Serack", sc.YourName);

                // our ThirdClass property should be set tho'
                Assert.Equal("Garrett", (sc as ThirdClass)?.SomeName);
            }
        }
    }
}