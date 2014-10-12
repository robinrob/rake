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


task :install do
   system("bundle install")
end


task :clean do
  system("find . -name '*~' -delete")
  # Mess created by git merge
  system("find . -name '*.orig' -delete")
  system("find . -name '*.BACKUP*' -delete")
  system("find . -name '*.BASE*' -delete")
  system("find . -name '*.LOCAL*' -delete")
  system("find . -name '*.REMOTE*' -delete")
  system("find . -name '*.class' -delete")
end


task :test, [:test_files] do |t, args|
  test_files = args[:test_files] || FileList['test*.rb', 'lib/test*.rb']
  Rake::TestTask.new do |t|
    t.libs << "."
    t.test_files = test_files
    t.verbose = true
  end
end


task :count, [:file_type, :dir] do |t, args|
  unless args[:file_type].to_s.strip.empty?
    count([args[:file_type]], args[:dir])
  else
    count(["*.rb"], args[:dir])
  end
end


def count(file_types, dir="./")
  Rake::Task["clean"].execute()
  
  name_part = ""
  file_types.each_with_index do |file_type, i|
    if i == 0
      name_part += "-name '#{file_type}'"
    else
      name_part += " -o -name '#{file_type}'"
    end
  end
  
  command = "find #{File.expand_path("../#{dir}", __FILE__)} '(' #{name_part} ')' -print0 | xargs -0 wc -l"
  puts command.green
  system(command)
end


task :count_all do
  count(["*.awk", "*.c", "*.cpp", "*.css", "*.html", "*.java", "*.js", "*.php", "*.pl", "*.py", "*.rb", "*.sh", "*.zsh"])
end


task :commit, [:msg] do |t, args|
  Rake::Task["clean"].execute()
  Rake::Task["add"].execute()
  Rake::Task["status"].execute()
  
  unless args[:msg].nil?
    msg = args[:msg]
  else
    msg = "Auto-update."
  end
  
  git("commit -m '#{msg}'")
end


task :add do
  git("add -A")
end


task :push do
  git("push origin " + branch())
end


task :pull do
  git("pull origin " + branch())
end


task :status do
  git("status")
end


task :save, [:msg] do |t, args|
  Rake::Task["commit"].execute()
  Rake::Task["pull"].execute()
  Rake::Task["push"].execute()
end


task :log do
  # Git formats
  git_log_medium_format = "%C(bold)Commit%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B"
  #git_log_oneline_format = "%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n"
  #git_log_brief_format = "%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n"


  # Git aliases
  #gl="git log --topo-order --pretty=format${_git_log_medium_format}" + wrap_quotes(git_log_medium_format)
  gls="git log --topo-order --stat --pretty=format" + wrap_quotes(git_log_medium_format)
  #gld="git log --topo-order --stat --patch --full-diff --pretty=format" + wrap_quotes(git_log_medium_format)
  #glo="git log --topo-order --pretty=format" + wrap_quotes(git_log_oneline_format)
  #glg="git log --topo-order --all --graph --pretty=format" + wrap_quotes(git_log_oneline_format)
  #glb="git log --topo-order --pretty=format" + wrap_quotes(git_log_brief_format)
  #glc="git shortlog --summary --numbered"

  system(gls)
end


def wrap_quotes(s)
  "'" + s + "'"
end


def git(command)
  system("git " + command)
end



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


task :sub_sort do
  GitConfigFile.new(:filename => '.gitmodules').sort!.save
  puts "Sorted .gitmodules file:".green
  puts `cat .gitmodules`.strip.yellow
end