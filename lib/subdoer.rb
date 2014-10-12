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
    _each_sub('./', command, config)
  end


  private
  def _each_sub(repo, command, config={})
    @counter += 1
    parent_dir = Dir.pwd
    Dir.chdir("#{repo.strip}")

    nest
    if config[:recurse_down]
      do_repo(repo, command, config)
    end

    if !config[:not_recursive] && File.exists?(".gitmodules")
      puts "#{indent}Recursing into #{repo} ...".light_cyan

      GitConfigReader.new.read(".gitmodules").each do |submodule|
        if submodule.derived_attrs[:owner] != Me
          puts "#{arrow} #{repo_owner(submodule.derived_attrs[:owner], submodule.attrs[:path])} #{not_me}'"
        else
         _each_sub(submodule.attrs[:path], command, config)
        end
      end

    end

    unless config[:recurse_down]
      do_repo(repo, command, config)
    end
    denest_to(parent_dir)
  end


  def do_repo(repo, command, config)
    puts "#{arrow} #{entering_repo(repo)}"

    command = "sh -c #{command}"
    if config[:quiet]
      `#{command}`
    else
      system("#{command}")
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