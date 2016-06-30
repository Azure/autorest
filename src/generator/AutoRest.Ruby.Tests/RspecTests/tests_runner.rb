# encoding: utf-8

require 'open3'

server_dir = "#{File.dirname(__FILE__)}/../../../dev/TestServer/server/"
Dir.chdir(server_dir){
  system('npm install')
}
random_port = 3000 + Random.rand(2000)
Dir.chdir("#{server_dir}/startup"){
  ENV['PORT'] = random_port.to_s
  @stdin, @stdout, @stderr, @wait_thr = Open3.popen3('node www.js')
  @pid = @wait_thr[:pid]
}

ENV['StubServerURI'] = "http://localhost:#{random_port}"

Dir.chdir("#{File.dirname(__FILE__)}/.."){
  system('bundle install')
  @exit_code = system("bundle exec rspec #{Dir['RspecTests/*_spec.rb'].join(' ')}")
}

@stdin.close
@stdout.close
@stderr.close

Process.kill(9, @pid)

exit @exit_code ? 0 : 1
