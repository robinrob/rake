class SubDoer


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
  def each_sub(command, recursive=true)
    _each_sub(command, @start_repo, recursive)
  end


  private
  def _each_sub(command, repo, recursive=true)
    @counter += 1
    parent_dir = Dir.pwd
    Dir.chdir("#{repo.strip}")

    if @nesting == 1 then puts "#{@indent}Recursing into #{repo} ...".cyan end
    if recursive && File.exists?(".gitmodules")

      submodules = GitConfigReader.new.read(".gitmodules")

      submodules.each do |submodule|
        owner = submodule[:owner]
        robinrob = 'robinrob'

        if owner == robinrob
          @indent << "\t|"
          @nesting += 1
          @nesting > @max_nesting ? @max_nesting = @nesting : false
          # @path << "#{repo}/"
          _each_sub(command, submodule[:path], recursive)
        else
          puts "Owner ".red << "#{owner.yellow}" << " not #{robinrob}!".red
        end
      end

      # puts "Recursion complete.".green
    end

    # @path = File.expand_path(Dir.new('./')).split("/")[-2..-1].join("/")
    puts "#{@indent}".cyan << "[".green << "#{@nesting}".cyan << "]>Entering repo: ".green << "#{repo}".cyan
    `#{command}`
    Dir.chdir(parent_dir)

    @nesting -= 1
    # if @nesting == 0 then puts end
    # if @nesting == 0 then puts "#{@indent}---------------------------------------------------------------------------".cyan end
    @indent = @indent[0..-3]
  end
end