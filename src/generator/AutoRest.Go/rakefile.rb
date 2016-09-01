# This file is use to generate Azure SDK from swagger. 
# Swaggers specs are located in git repo: https://github.com/Azure/azure-rest-api-specs

require 'fileutils'

AUTOREST     = "../../core/AutoRest/bin/Debug/net451/win7-x64/AutoRest.exe"

SWAGGER_VERSIONS = {
	authorization: {version: "2015-07-01"},
	batch: {version: "2015-12-01", swagger: "BatchManagement"},
	cdn: {version: "2016-04-02"},
	cognitiveservices: {version: "2016-02-01-preview"},
	compute: {version: "2016-03-30"},
	# containerservice: {version: "2016-03-30", swagger: "containerservice"},
	# commerce: {version: "2015-06-01-preview"},
	# datalake_analytics: {
	# 	account: {version: "2015-10-01-preview"},
	# 	catalog: {version: "2015-10-01-preview"},
	# 	job:  {version: "2016-03-20-preview"}
	# },
	datalake_store: {
		account: {version: "2015-10-01-preview"},
		filesystem: {version: "2015-10-01-preview"}
	},
	devtestlabs: {version: "2016-05-15", swagger: "DTL"},
	dns: {version: "2016-04-01"},
	# eventhub: {version: "2015-08-01", swagger: "EventHub"},
	# graphrbac: {version: "1.6"},
	intune: {version: "2015-01-14-preview"},
	iothub: {version: "2016-02-03"},
	keyvault: {version: "2015-06-01"},
	logic: {version: "2016-06-01"},
	machinelearning: {version: "2016-05-01-preview", swagger: "webservices"},
	mediaservices: {version: "2015-10-01", swagger: "media"},
	mobileengagement: {version: "2014-12-01", swagger: "mobile-engagement"},
	network: {version: "2016-06-01"},
	notificationhubs: {version: "2016-03-01"},
	powerbiembedded: {version: "2016-01-29"},
	redis: {version: "2016-04-01"},
	resources: {
		features: {version: "2015-12-01"},
		locks: {version: "2015-01-01"},
		resources: {version: "2016-07-01"},
		policy: {version: "2016-04-01"},
		subscriptions: {version: "2015-11-01"}
	},
	scheduler: {version: "2016-03-01"},
	search: {version: "2015-02-28"},
	# servermanagement: {version: "2015-07-01-preview"},
	servicebus: {version: "2015-08-01"},
	sql: {version: "2015-05-01"},
	storage: {version: "2016-01-01"},
	trafficmanager: {version: "2015-11-01"},
	web: {version: "2015-08-01", swagger: "service"}
}

class Service
	GO_NAMESPACE = "github.com/Azure/azure-sdk-for-go/arm/%s"
	INPUT_PATH   = "../../../../azure-rest-api-specs/arm-%s/swagger/%s.json"
	OUTPUT_PATH  = "#{ENV['GOPATH']}/src/github.com/azure/azure-sdk-for-go/arm/%s"

	attr :name
	attr :fullname
	attr :namespace
	attr :packages
	attr :task_name
	attr :version

	attr :input_path
	attr :output_path

	def initialize(service)
		@packages = service[:packages]
		@name = @packages.last
		@fullname = @packages.map{|package| package.to_s.gsub(/_/,'-')}.join('/')
		@namespace = sprintf(GO_NAMESPACE, @fullname)
		@task_name = @packages.join(':')
		@version = service[:version]
		
		swagger = service[:swagger] || @name
		@input_path = sprintf(INPUT_PATH, [@fullname, @version].join('/'), swagger)
		@output_path = sprintf(OUTPUT_PATH, @fullname)
	end
end

def to_services(m, h, *p)
  if h.keys.include?(:version)
    h[:packages] = p.reverse
    m << Service.new(h)
  else
    h.keys.each do |k|
      to_services(m, h[k], k, *p)
    end
  end
  m
end

SERVICES = to_services([], SWAGGER_VERSIONS)

desc "Generate, format, and build all services"
task :default => 'generate:all'

desc "List the known services"
task :services do
	SERVICES.each do |service|
		puts "#{service.task_name}"
	end
end

namespace :generate do
	desc "Generate all services"
	task :all do
		SERVICES.each {|service| Rake::Task["generate:#{service.task_name}"].execute }
	end

	SERVICES.each do |service|
		desc "Generate the #{service.task_name} service"
		task service.task_name.to_sym do
			generate(service)
		end
	end
end

namespace :go do
	namespace :delete do
		desc "Delete all generated services"
		task :all do
			SERVICES.each {|service| delete(service) }
		end

		SERVICES.each do |service|
			desc "Delete the #{service.task_name} service"
			task service.task_name.to_sym do
				delete(service)
			end
		end
	end

	namespace :format do
		desc "Format all generated services"
		task :all do
			SERVICES.each {|service| format(service) }
		end

		SERVICES.each do |service|
			desc "Format the #{service.task_name} service"
			task service.task_name.to_sym do
				format(service)
			end
		end
	end

	namespace :build do
		desc "Build all generated services"
		task :all do
			SERVICES.each {|service| build(service) }
		end

		SERVICES.each do |service|
			desc "Build the #{service.task_name} service"
			task service.task_name.to_sym do
				build(service)
			end
		end
	end

	namespace :lint do
		desc "Lint all generated services"
		task :all do
			SERVICES.each {|service| lint(service) }
		end

		SERVICES.each do |service|
			desc "Lint the #{service.task_name} service"
			task service.task_name.to_sym do
				lint(service)
			end
		end
	end

	namespace :vet do
		desc "Vet all generated services"
		task :all do
			SERVICES.each {|service| vet(service) }
		end

		SERVICES.each do |service|
			desc "Vet the #{service.task_name} service"
			task service.task_name.to_sym do
				vet(service)
			end
		end
	end
end

def generate(service)
	s = "Generating #{service.fullname}.#{service.version} "
	puts "#{s} #{"=" * (80 - s.length)}"
	delete(service)
	s = `#{AUTOREST} -AddCredentials -CodeGenerator Go -Header MICROSOFT_APACHE -Input #{service.input_path} -Namespace #{service.namespace} -OutputDirectory #{service.output_path} -Modeler Swagger`
	raise "Failed generating #{service.fullname}.#{service.inspect}" if s =~ /.*FATAL.*/
	puts s

	format(service)
	build(service)
	lint(service)
	vet(service)
end

def delete(service)
	puts "Deleting #{service.fullname}"
	FileUtils.rmtree(service.output_path)
end

def format(service)
	puts "Formatting #{service.fullname}"
	s = `gofmt -w #{service.output_path}`
	raise "Formatting #{service.output_path} failed:\n#{s}\n" if $?.exitstatus > 0
end

def build(service)
	puts "Building #{service.fullname}"
	s = `go build #{service.namespace}`
	raise "Building #{service.namespace} failed:\n#{s}\n" if $?.exitstatus > 0
end

def lint(service)
	puts "Linting #{service.fullname}"
	s = `#{ENV["GOPATH"]}\\bin\\golint #{service.namespace}`
	print s
end

def vet(service)
	puts "Vetting #{service.fullname}"
	s = `go vet #{service.namespace}`
	print s
end