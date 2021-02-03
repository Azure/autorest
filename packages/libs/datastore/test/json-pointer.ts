import { keys } from '@azure-tools/linq';
import * as assert from 'assert';
import { only, skip, slow, suite, test, timeout } from 'mocha-typescript';
import * as pointer from '../main';

let rfcExample: any;
let rfcValues: any;
let rfcParsed: any;

@suite class JsonPointer {
  before() {
    rfcExample = {
      'foo': ['bar', 'baz'],
      'bar': { 'baz': 10 },
      '': 0,
      'a/b': 1,
      'c%d': 2,
      'e^f': 3,
      'g|h': 4,
      'i\\j': 5,
      'k"l': 6,
      ' ': 7,
      'm~n': 8
    };

    rfcValues = {
      '': rfcExample,
      '/foo': rfcExample.foo,
      '/foo/0': 'bar',
      '/bar': rfcExample.bar,
      '/bar/baz': 10,
      '/': 0,
      '/a~1b': 1,
      '/c%d': 2,
      '/e^f': 3,
      '/g|h': 4,
      '/i\\j': 5,
      '/k"l': 6,
      '/ ': 7,
      '/m~0n': 8
    };

    rfcParsed = {
      '': { tokens: [], value: rfcExample },
      '/foo': { tokens: ['foo'], value: rfcExample.foo },
      '/foo/0': { tokens: ['foo', '0'], value: 'bar' },
      '/bar': { tokens: ['bar'], value: rfcExample.bar },
      '/bar/baz': { tokens: ['bar', 'baz'], value: 10 },
      '/': { tokens: [''], value: 0 },
      '/a~1b': { tokens: ['a/b'], value: 1 },
      '/c%d': { tokens: ['c%d'], value: 2 },
      '/e^f': { tokens: ['e^f'], value: 3 },
      '/g|h': { tokens: ['g|h'], value: 4 },
      '/i\\j': { tokens: ['i\\j'], value: 5 },
      '/k"l': { tokens: ['k"l'], value: 6 },
      '/ ': { tokens: [' '], value: 7 },
      '/m~0n': { tokens: ['m~n'], value: 8 }
    };
  }

  @test 'should work for root element'() {
    const obj = {};
    assert(pointer.get(obj, '') === obj);

  }

  @test 'should do examples'() {
    for (const p of keys(rfcValues)) {
      const expectedValue = rfcValues[p];
      assert(pointer.get(rfcExample, p) === expectedValue);
    }
  }
  @test 'should create arrays for - and reference the (nonexistent) member after the last array element.'() {
    const obj = <any>['foo'];
    pointer.set(obj, '/-/test/-', 'expected');
    assert(Array.isArray(obj), 'should be an array');
    assert(obj.length === 2, 'length should be 2');
    assert(Array.isArray(obj[1].test), 'should be an array too');
    assert(obj[1].test.length === 1, 'should be length 1 ');
    assert(obj[1].test[0] === 'expected', 'expected');
  }

  @test 'should return a dictionary (pointer -> value)'() {
    const obj = {
        bla: {
          test: 'expected'
        },
        abc: 'bla'
      },
      dict = pointer.toDictionary(obj);

    assert(dict['/bla/test'] === 'expected');
    assert(dict['/abc'] === 'bla');
  }

  @test 'should work with arrays'() {
    const obj = {
        'users': [
          { 'name': 'example 1' },
          { 'name': 'example 2' }
        ]
      },
      dict = pointer.toDictionary(obj),
      pointers = Object.keys(dict);

    assert(pointers.length === 2);
    assert(pointers[0] === '/users/0/name');
    assert(pointers[1] === '/users/1/name');
  }

  @test 'should work with other arrays'() {
    const obj = {
        bla: {
          bli: [4, 5, 6]
        }
      },
      dict = pointer.toDictionary(obj);
    assert(dict['/bla/bli/0'] === 4);
    assert(dict['/bla/bli/1'] === 5);
    assert(dict['/bla/bli/2'] === 6);
  }

  @test 'should return true when the pointer exists'() {
    const obj = {
      bla: {
        test: 'expected'
      },
      foo: [['hello']],
      abc: 'bla'
    };
    assert(pointer.has(obj, '/bla') === true);
    assert(pointer.has(obj, '/abc') === true);
    assert(pointer.has(obj, '/foo/0/0') === true);
    assert(pointer.has(obj, '/bla/test') === true);
  }

  @test 'should return true when the tokens point to value'() {
    const obj = {
      bla: {
        test: 'expected'
      },
      foo: [['hello']],
      abc: 'bla'
    };
    assert(pointer.has(obj, ['bla']) === true);
    assert(pointer.has(obj, ['abc']) === true);
    assert(pointer.has(obj, ['foo', '0', '0']) === true);
    assert(pointer.has(obj, ['bla', 'test']) === true);
  }

  @test 'should return false when the pointer does not exist'() {
    const obj = {
      bla: {
        test: 'expected'
      },
      abc: 'bla'
    };
    pointer.has(obj, '/not-existing') === false;
    pointer.has(obj, '/not-existing/bla') === false;
    pointer.has(obj, '/test/1/bla') === false;
    pointer.has(obj, '/bla/test1') === false;
  }

  @test 'should return false when the tokens do not point to value'() {
    const obj = {
      bla: {
        test: 'expected'
      },
      abc: 'bla'
    };
    assert(pointer.has(obj, ['not-existing']) === false);
    assert(pointer.has(obj, ['not-existing', 'bla']) === false);
    assert(pointer.has(obj, ['test', '1', 'bla']) === false);
    assert(pointer.has(obj, ['bla', 'test1']) === false);
  }

  @test 'should iterate over an object'() {
    pointer.walk({ bla: { test: 'expected' } }, (value, ptr) => {
      assert(ptr === '/bla/test');
      assert(value === 'expected');
    });
  }

  @test 'non-recursive visit pattern'() {
    const obj = {
      foo: 100,
      bar: 'hello',
      bin: {
        b1: 'string',
        b2: 0,
        b3: ['a', 'b', 'c'],
        b4: {
          box: 'sad'
        }
      }
    };

    for (const each of pointer.visit(obj)) {
      switch (each.key) {
        case 'foo':
          assert(each.value === 100);
          break;

        case 'bar':
          assert(each.value === 'hello');
          break;

        case 'bin':
          assert(typeof each.value === 'object');

          for (const item of each.children) {
            switch (item.key) {
              case 'b1':
                assert(item.value === 'string');
                break;

              case 'b2':
                assert(item.value === 0);
                break;

              case 'b3':
                assert(Array.isArray(item.value) === true);
                for (const i of item.children) {
                  assert(typeof i.value === 'string');
                }
                break;

              case 'b4':
                assert(typeof (item.value) === 'object');
                break;
            }

          }
      }
    }
  }
}
