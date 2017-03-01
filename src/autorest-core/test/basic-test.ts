import { suite, test, slow, timeout, skip, only } from "mocha-typescript";

@suite class Hello {
    @test "sample test"() {
        // if this is uncommented, the build will fail. 
        // throw "fails"
    }
}