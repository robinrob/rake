require 'colorize'
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
  git("push -u origin " + branch())
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