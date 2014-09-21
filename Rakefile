$LOAD_PATH << '.'

require 'csv'
require 'colorize'


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
  # Artifacts from git merge  
  system("find . -name '*.orig' -delete")
  system("find . -name '*.BACKUP*' -delete")
  system("find . -name '*.BASE*' -delete")
  system("find . -name '*.LOCAL*' -delete")
  system("find . -name '*.REMOTE*' -delete")
  system("find . -name '*.class' -delete")
end


task :test do
  puts "Needs implementing!".red
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
#
# Example: rake sub_deinit[projects/ruby]
# Example: rake sub_deinit[all]
task :sub_deinit, [:arg1] do |t, args|
  submodule = args[:arg1]
  deinit(submodule)
end


def deinit(submodule)
  puts "Deinit repo: ".red + "#{submodule}".green
  `rm -rf #{submodule}`
  `git rm -rf --ignore-unmatch --cached #{submodule}`
  `git submodule deinit #{submodule} 2> /dev/null`
  # `rm -rf .git/modules/#{repo}`
end


task :each_sub, [:command, :submodule, :recursive] do |t, args|
  command = args[:command]
  submodule = args[:submodule].nil? ? "./" : args[:submodule]
  recursive = args[:recursive].nil? ? true : false

  doer = SubDoer.new
  
  unless command.nil?
    puts "Recursive mode!".blue if recursive
  
    doer.each_sub(command, submodule, recursive)
  end

  puts "Ran for ".green << "#{doer.counter}".yellow << " repositories.".green \
  << " Max nesting: ".green << "#{doer.max_nesting}".yellow << ".".green
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


class SubDoer


  attr_accessor :counter, :max_nesting

  def initialize
    @indent=""
    @nesting=0
    @max_nesting=@nesting
    @counter=0
    @path=""
  end


  def each_sub(command, repo=`echo ${PWD##*/}`, recursive=true)
    @counter += 1
    parent_dir = Dir.pwd
    Dir.chdir("#{repo.strip}")

    if @nesting == 1 then puts "Recursing into #{repo} ...".cyan end
    if recursive && File.exists?(".gitmodules")
      # puts "Recursing into #{repo} ...".cyan

      submodules = GitConfigReader.new.read(".gitmodules")

      submodules.each do |submodule|
        owner = submodule[:owner]
        robinrob = 'robinrob'

        if owner == robinrob
          @indent << "\t|"
          @nesting += 1
          @nesting > @max_nesting ? @max_nesting = @nesting : false
          # @path << "#{repo}/"
          each_sub(command, submodule[:path], recursive)
        else
          puts "Owner ".red << "#{owner.yellow}" << " not #{robinrob}!".red
        end
      end

      # puts "Recursion complete.".green
    end

    puts "#{@indent}".cyan << "[".green << "#{@nesting}".cyan << "]>Entering repo: ".green << "#{repo}".cyan
    # puts "#{"\t|" * @nesting}".cyan
    `#{command}`
    @indent = @indent[0..-3]
    @nesting -= 1
    @path = @path.split("/")[0..-2].join("/")
    Dir.chdir(parent_dir)
  end
end


# Reads a with format of .gitconfig, for example .gitmodules and returns an array of hashes.
# Each hash represents a section of the config file, containing the config in a 'flat' csv-like structure.
class GitConfigReader

  Indent=4

  def read(filename='.gitconfig')
    text = `cat #{filename}`
    text.strip()

    sections = []

    unless text == ''
      text.split(/(\[.*\])/)[1..-1].each_slice(2) { |s| sections << read_section(s.join.split("\n")) }
    end

    sections
  end

  private
  def read_section(lines)
    section = {}

    counter = 0
    lines[0..-1].each do |line|
      if counter == 0
        comps = line.gsub('[', '').gsub(']', '').split(' ')
        section['type'.to_sym] = comps[0]
        if comps.length == 2 then section['name'.to_sym] = comps[1] end

      elsif line.match(/.*=.*/)
        comps = line.split('=')

        key = comps[0].strip()
        val = comps[1].strip()

        section[key.to_sym] = val
      end

      counter += 1
    end
    section[:owner] = parse_owner(section[:url])
    section
  end


  def parse_owner(repo)
    repo.strip!
    if repo.include?('https')
      repo.split('/')[3].split('/')[0]
    else
      repo.split(':')[1].split('/')[0]
    end
  end
  
end