$LOAD_PATH << '.'
$LOAD_PATH << 'lib'
$LOAD_PATH << 'rake'
$LOAD_PATH << 'rake/lib'

require 'csv'
require 'colorize'
require 'gitrepo'
require 'gitconfigfile'
require 'rake/testtask'


# Load the 'base' tasks
Dir.glob('*.rake').each { |r| load r}
Dir.glob('rake/*.rake').each { |r| load r}


# Ruby on Rails development
if File.exists?("config/application.rb")
  require File.expand_path('../config/application', __FILE__)
  Rails.application.load_tasks
end


namespace :git do
	desc 'Deinit a submodule and remove it from .gitmodules.'
	task :deinit, [:arg1] do |t, args|
	  submodule = args[:arg1]
	
	  puts "Deinit repo: ".red + "#{submodule}".green
	  `rm -rf #{submodule}`
	  `git rm -rf --ignore-unmatch --cached #{submodule}`
	  `git submodule deinit #{submodule} 2> /dev/null`
	
	  file = GitConfigFile.new(:filename => '.gitmodules')
	  file.del_block submodule
	  file.sort!
	  file.save
  end


  desc 'Perform a command for all repositories at and below the current level
  in the tree.'
  task :foreach, [:command, :quiet, :recurse_down] do |t, args|
    command = args[:command]
    quiet = args[:quiet] || false
    recurse_down = args[:recurse_down].nil? ? false : true

    config = { :quiet => quiet, :recurse_down => recurse_down}

    unless command.nil?
      puts "Quiet mode!".light_blue if quiet

      result = GitRepo.new(:name => 'root', :path => './').each_sub(command, config)
    end

    puts "Ran for ".green << "#{result[:counter]}".yellow << " repositories.".green \
	  << " Max nesting: ".green << "#{result[:max_nesting]}".yellow << ".".green
  end


  desc 'Sort .gitmodules file alphabetically by submodule name.'

  task :sort_sub do
    GitConfigFile.new(:filename => '.gitmodules').sort!.save
    puts "Sorted .gitmodules file:".green
    puts `cat .gitmodules`.strip.yellow
  end
end


namespace :rails do
  desc 'Start Rails server.'
	task :server => 'rails:kill' do
	  Rake::Task["kill"].execute()
	  system("rails server")
	end


  desc 'Kill Rails server.'
  task :kill do
   system("kill `cat tmp/pids/server.pid 2> /dev/null` 2> /dev/null")
  end


  desc 'Precompile Rails assets.'
  task :precompile do
    system("RAILS_ENV=production bundle exec rake assets:precompile")
  end


  desc 'Deploy the Rails project to Heroku, pre-compiling assets first.'
  task :deploy, [:environment] => ['rails:precompile', :install, :save] do |t, args|
    environment = args[:environment] || 'production'
    puts "Deploying to: ".green << "#{environment}".yellow

    system("git push #{environment} master")
    system("heroku run rake db:migrate")
  end
end


task :hashes do
  desc 'Replace all new-syntax hashes in the project with hash-rocket syntax.'

  cmd = "gfind . -iregex '.*\\(rb\\|haml\\)' -printf '%p\n'"
  files = `#{cmd}`.split("\n")

  files.each do |file|
    puts "Converting file: ".green << "#{file}".yellow
    `gsed -i "s/\\([a-z_]\\+\\):\\{1\\}\s\\+\\(\\('\\|"'"'"\\)\\?[-a-zA-Z0-9{}:@]\\+\\('\\|"'"'"\\)\\?\\)/:\\1 => \\2/g" #{file}`
  end
end


namespace :cocos do
  desc 'Run the project in the default browser.'
	task :run do
	  system("cocos run -p web -b '#{ENV['BROWSER']}'")
	end
end