require 'GitConfigReader'
require 'GitRepo'

class SubDoer

  Indentation = "\t\t|"
  Me = 'robinrob'


  attr_accessor :counter, :max_nesting


  def initialize()
    @depth = 0
    @max_nesting = @depth
    @counter = 0
    @path = ''
  end


  public
  def each_sub(command, config={})
    _each_sub(GitRepo.new({
                              :name => 'root',
                              :path => './',
                              :owner => 'robinrob'}
              ), command, config)
  end


  private
  def _each_sub(repo, command, config={})
    @counter += 1
    parent_dir = Dir.pwd
    Dir.chdir("#{repo.path}")

    repo = fill_submodules(repo)

    nest
    if config[:recurse_down]
      do_repo(repo, command, config)
    end

    if !config[:not_recursive] && (repo.submodules.length > 0)
      puts "#{indent}Recursing into #{repo.path} ...".light_cyan

      repo.submodules.each do |submodule|
        _each_sub(submodule, command, config)
      end

    end

    unless config[:recurse_down]
      do_repo(repo, command, config)
    end
    denest_to(parent_dir)
  end


  def fill_submodules(repo)
    if File.exists? '.gitmodules'
      blocks = GitConfigReader.new.read '.gitmodules'
      blocks.each do |block|
        repo.add_sub GitRepo.new({
                                     :name => block.name,
                                     :path => block.attrs[:path],
                                     :owner => block.derived_attrs[:owner]
                                 })
      end
    end
    repo
  end


  def do_repo(repo, command, config)
    puts "#{arrow} #{entering_repo(repo.path)}"

    if repo.owner == Me
      if config[:quiet]
        `#{command}`
      else
        system("#{command}")
      end

    else
      puts "#{indent}#{repo_owner(repo.owner, repo.path)} #{not_me}'"
    end
  end


  def arrow
    "#{indent}".cyan << "[".green << "#{nesting}".cyan << "]>".green
  end


  def repo_owner(owner, repo)
    "Owner ".red << "#{owner.yellow}" << " of repo ".red << "#{repo}".yellow
  end


  def not_me
    "not #{Me}!".red
  end


  def entering_repo(repo)
    "Entering repo: ".green << "#{repo}".cyan
  end


  def indent
    Indentation * nesting
  end


  def nesting
    @depth - 1
  end


  def nest
    @depth += 1
    if nesting > @max_nesting then @max_nesting = nesting end
  end


  def denest_to(parent_dir)
    @depth -= 1
    Dir.chdir(parent_dir)
  end

end