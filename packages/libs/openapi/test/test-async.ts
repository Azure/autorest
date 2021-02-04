import { suite, test, slow, timeout, skip, only } from 'mocha-typescript';
import * as assert from 'assert';

@suite class MyTests {

  @test async 'Does tests work'() { // tslint:disable-line
    assert(1 === 1, '1 is 1');
  }

}