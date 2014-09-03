require 'csv'
require 'colorize'


HOME = File.expand_path("../", __FILE__)


task :init do
  install()
  git("submodule init")
  update()
end


task :install do
   system("bundle install")
end


task :clean do
  system("find . -name '*~' -delete")
  system("find . -name '*.orig' -delete")
end


task :test do
  puts "Needs implementing!"
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


task :deploy do
  Rake::Task["install"].execute()
  Rake::Task["save"].execute()
  system("rake assets:precompile")
  git("push heroku master")
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
task :sub_deinit, [:arg1] do |t, args|
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


task :sub_gcm, [:submodule, :recursive] do |t, args|
  Rake::Task["sub_cmd"].invoke("git checkout master", args[:submodule], args[:recursive])
end


# This task recursively performs :command for all submodules.
# Recursion depends upon presence of "submodules.csv" file in each repo with submodules.
# Recursion can be turned off by providing a value for second argument.
task :sub_cmd, [:command, :submodule, :recursive] do |t, args|
  command = args[:command]
  submodule = args[:submodule].nil? ? "./" : args[:submodule]
  recursive = args[:recursive].nil? ? true : false
  
  unless command.nil?
    puts "Recursive mode!".blue if recursive
  
    each_sub(command, submodule, recursive)
  end
end


def each_sub(command, repo="./", recursive=true)
  parent_dir = Dir.pwd
  Dir.chdir("#{repo}")
  
  if recursive && File.exists?("submodules.csv")
    puts "Recursing into #{repo} ...".cyan
    
    CSV.foreach("submodules.csv", :headers => true) do |row|
      each_sub(command, row["Repo"], recursive)
    end
    
    puts "Recursion complete.".cyan
  end
  
  puts "Entering repo: #{repo}".green
  `#{command}`
  # system("zsh -c 'source ~/.zshrc > /dev/null && rks'")
  Dir.chdir(parent_dir)
end


def branch()
  `git branch`[2..-2]
end
