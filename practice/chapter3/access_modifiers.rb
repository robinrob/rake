class Robin
  
  def robin1
    puts "robin 1"
  end

  def robin2
    puts "robin 2"
  end

  def robin3
    puts "robin 3"
  end

  private :robin1
  
  public

  :robin2
  
  protected :robin3

  private

  def robin4
  # ...
  end

  def robin5
  # ...
  end

end

class Smith < Robin
  def smith1
    robin1()
  end
  
  def smith3
    robin3()
  end
end

Robin.new().robin2()
Smith.new().smith4()
Smith.new().smith5()