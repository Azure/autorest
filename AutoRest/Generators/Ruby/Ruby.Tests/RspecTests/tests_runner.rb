# encoding: utf-8

require 'open3'

server_dir = "#{File.dirname(__FILE__)}/../../../../AcceptanceTests/server/"
Dir.chdir(server_dir){
  system('npm install')
}
Dir.chdir("#{server_dir}/startup"){
  @stdin, @stdout, @stderr, @wait_thr = Open3.popen3('node www.js')
  @pid = @wait_thr[:pid]
}
ENV['StubServerURI'] = 'http://localhost:3000'
Dir.chdir("#{File.dirname(__FILE__)}/.."){
  @exit_code = system('bundle exec rspec RspecTests/*_spec.rb')
}

@stdin.close
@stdout.close
@stderr.close
Process.kill(9, @pid)
exit @exit_code ? 0 : 1