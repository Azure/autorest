# Pull In Mocking Support 
. "$PSScriptRoot/HttpPipelineMocking.ps1"

# Run Some tests
Describe 'Get-Article Tests' {
    It "gets sports articles" {
       (get-article -section sports -source nyt -HttpPipelineAppend $mock).Results.length | Should -be 20 
    }
}