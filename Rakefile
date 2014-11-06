$LOAD_PATH << '.'
$LOAD_PATH << 'lib'
$LOAD_PATH << 'rake'
$LOAD_PATH << 'rake/lib'

require 'csv'
require 'colorize'
require 'gitrepo'
require 'gitconfigfile'
require 'rake/testtask'


# Ruby on Rails development
if File.exists?("config/application.rb")
  require File.expand_path('../config/application', __FILE__)
  Rails.application.load_tasks
end

Dir.glob('*.rake').each { |r| load r}



# This task de-initialises the specified submodule, given by its relative path.
task :sub_deinit, [:arg1] do |t, args|
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


task :each_sub, [:command, :quiet, :recurse_down] do |t, args|
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


def branch()
  `git branch`[2..-2]
end


# Ruby on Rails development
task :server do
  Rake::Task["kill"].execute()
  system("rails server")
end


task :kill do
  system("kill `cat tmp/pids/server.pid 2> /dev/null` 2> /dev/null")
end


task :deploy do
  system("RAILS_ENV=production bundle exec rake assets:precompile")
  # system("rake assets:precompile")
  Rake::Task["install"].execute()
  Rake::Task["save"].execute()
  # system("rake assets:precompile")
  system("git push heroku master")
  system("heroku run rake db:migrate")
end


# Convert new ruby hash syntax into normal syntax
task :hashes do
  cmd = "gfind . -iregex '.*\\(rb\\|haml\\)' -printf '%p\n'"
  files = `#{cmd}`.split("\n")

  files.each do |file|
    puts "Converting file: ".green << "#{file}".yellow
    `gsed -i "s/\\([a-z_]\\+\\):\\{1\\}\s\\+\\(\\('\\|"'"'"\\)\\?[-a-zA-Z0-9{}:@]\\+\\('\\|"'"'"\\)\\?\\)/:\\1 => \\2/g" #{file}`
  end
end


task :sort_sub do
  GitConfigFile.new(:filename => '.gitmodules').sort!.save
  puts "Sorted .gitmodules file:".green
  puts `cat .gitmodules`.strip.yellow
end


task :run do
  system("cocos run -p web -b '#{ENV['BROWSER']}'")
end
