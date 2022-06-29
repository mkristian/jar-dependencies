# frozen_string_literal: true

task default: [:specs]

require 'bundler/gem_tasks'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

desc 'run specs'
task :specs do
  $LOAD_PATH << 'specs'

  Dir['specs/*_spec.rb'].each do |f|
    require File.basename(f.sub(/.rb$/, ''))
  end
end
