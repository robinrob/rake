class GitRepo

  attr_accessor :name, :submodules, :owner, :path

  def initialize(config)
    @name = config[:name]
    @path = config[:path]
    @submodules = config[:submodules] || []
    @owner = config[:owner]
  end


  def add_sub(sub)
    @submodules << sub
  end

end