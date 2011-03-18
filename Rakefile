require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require File.join(File.dirname(__FILE__), 'lib', 'loginza', 'version')

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the loginza plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the loginza plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Loginza'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "loginza"
    gemspec.version = Loginza::Version.dup
    gemspec.summary = "Rails plugin for openID authentication by service Loginza.API"
    gemspec.description = "Loginza - an interactive JavaScript widget provides visitors to your sites, a wide range of options for authentication through the accounts of common WEB-portals and services"
    gemspec.email = "galeta.igor@gmail.com"
    gemspec.homepage = "http://loginza.ru/"
    gemspec.authors = ["Igor Galeta"]
    gemspec.files = FileList["[A-Z]*", "{lib,rails}/**/*"]
    gemspec.rubyforge_project = "loginza"
    
    gemspec.add_dependency('json')
  end
  
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
