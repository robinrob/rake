require 'csv'
require 'colorize'


HOME = File.expand_path("../", __FILE__)


task :init do
  install()
  git("submodule init")
  update()
end


task :update do
  update()
end


def update()
  git("submodule foreach git pull origin master")
end


task :install do
   do_install()
end


def do_install()
  system("bundle install")
end


def install_ruby()
  rvm("install " + RUBY)
  use_ruby(RUBY)
end


def use_ruby(version)
  rvm("use " + version)
end


def rvm(command)
  system("rvm " + command)
end


task :clean do
  clean()
end


def clean()
  system("find . -name '*~' -delete")
  system("find . -name '*.orig' -delete")
end


task :test do
  puts "Needs implementing!"
end

task :count, [:file_type] do |t, args|
  unless args[:file_type].to_s.strip.empty?
    count([args[:file_type]])
  else
    count(["*.rb"])
  end
end


def count(file_types)
  clean()
  
  name_part = ""
  file_types.each_with_index do |file_type, i|
    if i == 0
      name_part += "-name '#{file_type}'"
    else
      name_part += " -o -name '#{file_type}'"
    end
  end
  
  command = "find #{HOME} '(' #{name_part} ')' -print0 | xargs -0 wc -l"
  puts command.green
  system(command)
end


task :count_all do
  count(["*.awk", "*.c", "*.cpp", "*.css", "*.html", "*.java", "*.js", "*.php", "*.pl", "*.py", "*.rb", "*.sh", "*.zsh"])
end

task :commit, [:msg] do |t, args|
  if !args[:msg].nil?
    commit(args[:msg])
  else
    commit()
  end
end


def commit(msg="Auto-update")
  clean()
  add()
  status()
  git("commit -m '#{msg}'")
end


task :add do
  add()
end


def add()
  git("add -A")
end


task :push do
  push(branch())
end


def push()
  git("push origin " + branch())
end


task :pull do
  pull()
end


def pull()
  git("pull origin " + branch())
end


task :status do
  status()
end


def status
  git("status")
end


task :save, [:msg] do |t, args|
  commit()
  pull()
  push()
end


task :deploy do
  Rake::Task["install"].execute()
  Rake::Task["save"].execute()
  system("rake assets:precompile")
  system("git push heroku master")
end


task :origin do
  git("remote show origin")
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


task :sub_add do
  
  CSV.foreach("submodules.csv", :headers => true) do |row|
  
    repo = row['Repo']
    url = row['URL']
    branch = row['Branch']
  
    system("git submodule add -b #{branch} -f #{url} #{repo}")
  end
  
end


# This task de-initialises the specified submodule, given by its relative path.
#
# Example: rake sub_deinit[projects/ruby]
# Example: rake sub_deinit[all]
task  :sub_deinit, [:arg1] do |t, args|
  submodule = args[:arg1]
  
  if submodule == "all"
    deinit_all()
  else
    deinit(submodule)
  end
  
end


def deinit_all()

  CSV.foreach("submodules.csv", :headers => true) do |row|

    deinit(row['Repo'])
  
  end

  # `rm -rf .git/modules/`

end


def deinit(submodule)
  puts "Deinit repo: ".red + "#{submodule}".green
  `rm -rf #{submodule}`
  `git rm -rf --ignore-unmatch --cached #{submodule}`
  `git submodule deinit #{submodule} 2> /dev/null`
  # `rm -rf .git/modules/#{repo}`
end


task :sub_update do
  `git submodule update --init --recursive`
end


# This task recursively performs "git checkout master" for all submodules.
# Recursion depends upon presence of file "submodules.csv" in each repo with submodules.
# Recursion can be turned off by providing a value for second argument.
#
# Example: rake sub_gcm[projects/ruby]
# Example: rake sub_gcm[projects/ruby, false]
# Example: rake sub_gcm[./]
# Example: rake sub_gcm
task :sub_gcm, [:submodule, :recursive] do |t, args|
  submodule = args[:submodule].nil? ? "./" : args[:submodule]
  recursive = args[:recursive].nil? ? true : false
  
  puts "Recursive mode!".blue if recursive
  
  gcm(submodule, recursive)
end


def gcm(repo="./", recursive=true)
  parent_dir = Dir.pwd
  Dir.chdir("#{repo}")
  
  if recursive && File.exists?("submodules.csv")
    puts "Recursing into #{repo} ...".blue
    
    CSV.foreach("submodules.csv", :headers => true) do |row|
      gcm(row["Repo"], recursive)
    end
    
    puts "Recursion complete.".blue
  end
  
  puts "Checkout master branch for repo: #{repo}".green
  system("git checkout master")
  Dir.chdir(parent_dir)
end


task :sub_rks, [:submodule, :recursive] do |t, args|
  submodule = args[:submodule].nil? ? "./" : args[:submodule]
  recursive = args[:recursive].nil? ? true : false
  
  puts "Recursive mode!".blue if recursive
  
  each_sub("rks", submodule, recursive)
end


def each_sub(command, repo="./", recursive=true)
  parent_dir = Dir.pwd
  Dir.chdir("#{repo}")
  
  if recursive && File.exists?("submodules.csv")
    puts "Recursing into #{repo} ...".blue
    
    CSV.foreach("submodules.csv", :headers => true) do |row|
      each_sub(command, row["Repo"], recursive)
    end
    
    puts "Recursion complete.".blue
  end
  
  puts "Entering repo: #{repo}".green
  system("zsh -c 'source ~/.zshrc > /dev/null && rks'")
  Dir.chdir(parent_dir)
end

def branch()
  `git branch`[2..-2]
end