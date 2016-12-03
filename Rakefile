# frozen_string_literal: true
require 'rake/testtask'

task :default do
  puts `rake -T`
end

Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

namespace :run do
  task :dev do
    sh 'rerun "rackup -p 9292"'
  end

  task :test do
    loop do
      puts 'Setting up test environment'
      ENV['RACK_ENV'] = 'test'
      Rake::Task['db:_setup'].execute
      Rake::Task['db:reset'].execute
      puts 'Populating test database'
      
      LoadCoursesFromAPI.call('')
      sh 'rerun "rackup -p 3000"'
    end
  end
end

namespace :db do
  task :_setup do
    require 'sequel'
    require_relative 'init' # no exist
    Sequel.extension :migration
  end

  desc 'Run database migrations'
  task migrate: [:_setup] do
    puts "Migrating to latest for: #{ENV['RACK_ENV'] || 'development'}"
    Sequel::Migrator.run(DB, 'db/migrations')
  end

  desc 'Reset migrations (full rollback and migration)'
  task reset: [:_setup] do
    Sequel::Migrator.run(DB, 'db/migrations', target: 0)
    Sequel::Migrator.run(DB, 'db/migrations')
  end
end

desc 'delete cassette fixtures'
task :wipe do
  sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
    puts(ok ? 'Cassettes deleted' : 'No casseettes found')
  end
end

namespace :quality do
  CODE = 'app.rb'

  desc 'run all quality checks'
  task all: [:rubocop, :flog, :flay]

  task :flog do
    sh "#{CODE}"
  end

  task :flay do
    sh "#{CODE}"
  end

  task :rubocop do
    sh 'rubocop'
  end
end