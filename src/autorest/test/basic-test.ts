import { suite, test, slow, timeout, skip, only } from "mocha-typescript";

@suite class Hello {
    @test "world"() { }
}