##How to run Ruby e2e tests

Do the following steps:
1. Install Ruby(virsion >= 2.1 is preffered). The easiest way to install Ruby is to [download installer](http://rubyinstaller.org/downloads/)
2. [Download](http://rubyinstaller.org/downloads/) and install DevKit for you Ruby's version. 
3. install rspec with 
```
gem install rspec
```
4. If there will be any required gems - install it.

###Generating client and running tests

1. Run server from folder AutoRest/Generators/AcceptanceTests/server/startup via `node www`
2. Build AutoRest.sln
3. From the root of your folder with hydra-pr run the following command to generate client.
```
 .\binaries\Net45-Debug\AutoRest.exe  -Modeler Swagger -CodeGenerator Ruby -OutputDirectory AutoRest\Generators\Ruby.e2e.Tests\Your-swagger-name -Namespace "MyNamespace" -Input [Path_to_your_swagger]\some-swagger.json 
```
NOTE: Do not rename folder for client or change path to this folder! Otherwise tests won't be able to find needed dependencies!
For example: if you chose body-boolean.json your command will looks like:
```
 .\binaries\Net45-Debug\AutoRest.exe  -Modeler Swagger -CodeGenerator Ruby -OutputDirectory AutoRest\Generators\Ruby.e2e.Tests\Boolean -Namespace "MyNamespace" -Input [path_to_body_boolean.json]\body-boolean.json 
```
4. Run the following commands to run all tests:
```
 cd AutoRest\CodeGenerators\Ruby.e2e.Tests
 set PORT=3000
 rspec --pattern *_spec.rb
```
Or you can use any IDE to run Ruby tests, it's up to your wishes.