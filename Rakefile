require 'csv'
require 'colorize'

RUBY = "2.0.0"

DEFAULT_BRANCH = "master"


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
   install()
end


def install()
  install_gems()
end


def install_gems()
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
  clean()
  system("find . -name '*.#{args[:file_type]}' | xargs wc -l")
end


task :commit do
  commit()
end


def commit()
  clean()
  add()
  status()
  git("commit -m 'Auto-update'")
end


def add()
  git("add -A")
end


task :push do(branch="master")
  push(branch)
end


def push(branch)
  git("push origin " + branch)
end


task :pull do(branch="master")
  pull(branch)
end


def pull(branch)
  git("pull origin " + branch)
end


task :status do
  status()
end


def status
  git("status")
end


task :save do(branch="master")
  commit()
  pull(branch)
  push(branch)
end


task :deploy do
  install()
  git("push heroku master")
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
  puts "Checkout master branch for repo: #{repo}".green
  parent_dir = Dir.pwd
  Dir.chdir("#{repo}")
  system("git checkout master")
  
  if recursive && File.exists?("submodules.csv")
    puts "Recursing into #{repo} ...".blue
    
    CSV.foreach("submodules.csv", :headers => true) do |row|
      gcm(row["Repo"], recursive)
    end
  end
  
  Dir.chdir(parent_dir)
end