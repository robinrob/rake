class SubDoer

  Indentation = "\t\t|"
  Me = 'robinrob'


  attr_accessor :counter, :max_nesting


  def initialize(start_repo)
    @start_repo = start_repo
    @indent=""
    @nesting=0
    @max_nesting=@nesting
    @counter=0
    @start_repo=start_repo
    @path=""
  end


  public
  def each_sub(command, config={})
    _each_sub(command, @start_repo, config)
  end


  private
  def _each_sub(command, repo, config={})
    @counter += 1
    parent_dir = Dir.pwd
    Dir.chdir("#{repo.strip}")

    if config[:recursive] && File.exists?(".gitmodules")
      puts "#{@indent}Recursing into #{repo} ...".light_cyan

      GitConfigReader.new.read(".gitmodules").each do |submodule|
        nest

        if submodule[:owner] == Me
          _each_sub(command, submodule[:path], config)
        else
          puts "#{arrow} #{repo_owner(submodule[:owner], submodule[:path])} #{not_me}"
        end
      end
    end

    puts entering_repo(repo)
    `#{command}`

    denest_to(parent_dir)
  end


  def arrow
    "#{@indent}".cyan << "[".green << "#{@nesting}".cyan << "]>".green
  end


  def repo_owner(owner, repo)
    "Owner ".red << "#{owner.yellow}" << " of repo ".red << "#{repo}".yellow
  end


  def not_me
    "not #{Me}!".red
  end


  def entering_repo(repo)
    "#{@indent}".cyan << "[".green << "#{@nesting}".cyan << "]>Entering repo: ".green << "#{repo}".cyan
  end


  def nest
    @nesting += 1
    @nesting > @max_nesting ? @max_nesting = @nesting : false
    indent
  end


  def denest_to(parent_dir)
    @nesting -= 1
    indent
    Dir.chdir(parent_dir)
  end


  def indent
    @indent = Indentation * @nesting
  end

end