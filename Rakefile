require "bundler/gem_tasks"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ["--format", "documentation"]
end

require 'redcarpet'
require 'yard'
require 'yard/rake/yardoc_task'
YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ["--list-undoc", "--no-private"]
end

task :separator do
  puts "\n"
end

task :default => [:spec, :separator, :yard]
