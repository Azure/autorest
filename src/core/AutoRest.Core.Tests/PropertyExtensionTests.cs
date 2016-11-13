// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Utilities;
using Xunit;
using Xunit.Abstractions;

namespace AutoRest.Core.Tests
{

    public class c1
    {
        public string s1 { get; set; } = nameof(s1);
        protected string s2 { get; set; } = nameof(s2);
        private string s3 { get; set; } = nameof(s3);
    }

    public class c2 : c1
    {
        
    }

    public class PropertyExtensionTests
    {
        private ITestOutputHelper _output;
        public PropertyExtensionTests(ITestOutputHelper output)
        {
            _output = output;
        }

        [Fact]
        public void GetTests()
        {
            var C1 = typeof(c1);
            var props = C1.DoGetProperties();
            var instance = new c1();

            foreach (var prop in props)
            {
                var get = prop.CreateGet();
                
                var value = get.DynamicInvoke(instance);
                _output.WriteLine($"{prop.Name} == {value}");
                Assert.Equal(prop.Name , value.ToString() );
            }

            instance = new c2();

            foreach (var prop in props)
            {
                var get = prop.CreateGet();

                var value = get.DynamicInvoke(instance);
                _output.WriteLine($"{prop.Name} == {value}");
                Assert.Equal(prop.Name, value.ToString());
            }

            foreach (var prop in props)
            {
                var get = prop.CreateGet<c1>();

                var value = get(instance);
                _output.WriteLine($"{prop.Name} == {value}");
                Assert.Equal(prop.Name, value.ToString());
            }

        }

        [Fact]
        public void GetFieldTests()
        {
            var C1 = typeof(c1);
            var fields = C1.DoGetFields();
            var instance = new c1();

            foreach (var field in fields)
            {
                var get = field.CreateGet();

                var value = get.DynamicInvoke(instance);
                _output.WriteLine($"{field.Name} == {value}");
                // Assert.Equal(prop.Name, value.ToString());
            }

            instance = new c2();

            foreach (var field in fields)
            {
                var get = field.CreateGet();

                var value = get.DynamicInvoke(instance);
                _output.WriteLine($"{field.Name} == {value}");
                // Assert.Equal(prop.Name, value.ToString());
            }

            foreach (var field in fields)
            {
                var get = field.CreateGet<c1>();

                var value = get(instance);
                _output.WriteLine($"{field.Name} == {value}");
                //  Assert.Equal(prop.Name, value.ToString());
            }
        }

        [Fact]
        public void SetFields()
        {
            var C1 = typeof(c1);
            var fields = C1.DoGetFields();
            var instance = new c1();

            foreach (var field in fields)
            {
                var set = field.CreateSet();
                var get = field.CreateGet();

                var value = get.DynamicInvoke(instance);
                _output.WriteLine($"{field.Name} == {value}");
                set.DynamicInvoke(instance, $"changed {value}");
                value = get.DynamicInvoke(instance);
                _output.WriteLine($"{field.Name} == {value}");
                
            }

            instance = new c2();

            foreach (var field in fields)
            {
                var set = field.CreateSet();
                var get = field.CreateGet();

                var value = get.DynamicInvoke(instance);
                _output.WriteLine($"{field.Name} == {value}");
                set.DynamicInvoke(instance, $"changed {value}");
                value = get.DynamicInvoke(instance);
                _output.WriteLine($"{field.Name} == {value}");
                // Assert.Equal(prop.Name, value.ToString());
            }

            foreach (var field in fields)
            {
                var set = field.CreateSet<c1>();
                var get = field.CreateGet<c1>();

                var value = get(instance);
                _output.WriteLine($"{field.Name} == {value}");
                set(instance, $"changed {value}");
                value = get(instance);
                _output.WriteLine($"{field.Name} == {value}");
            }
        }

        [Fact]
        public void SetProperties()
        {
            var C1 = typeof(c1);
            var properties = C1.DoGetProperties();
            var instance = new c1();

            foreach (var property in properties)
            {
                var set = property.CreateSet();
                var get = property.CreateGet();

                var value = get.DynamicInvoke(instance);
                _output.WriteLine($"{property.Name} == {value}");
                set.DynamicInvoke(instance, $"changed {value}");
                value = get.DynamicInvoke(instance);
                _output.WriteLine($"{property.Name} == {value}");

            }

            instance = new c2();

            foreach (var property in properties)
            {
                var set = property.CreateSet();
                var get = property.CreateGet();

                var value = get.DynamicInvoke(instance);
                _output.WriteLine($"{property.Name} == {value}");
                set.DynamicInvoke(instance, $"changed {value}");
                value = get.DynamicInvoke(instance);
                _output.WriteLine($"{property.Name} == {value}");
                // Assert.Equal(prop.Name, value.ToString());
            }

            foreach (var property in properties)
            {
                var set = property.CreateSet<c1>();
                var get = property.CreateGet<c1>();

                var value = get(instance);
                _output.WriteLine($"{property.Name} == {value}");
                set(instance, $"changed {value}");
                value = get(instance);
                _output.WriteLine($"{property.Name} == {value}");
            }
        }
    }
}