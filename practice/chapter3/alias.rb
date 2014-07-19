class Robin
  
  def smith()
    puts "smith"
  end
  
  alias badass smith
  
end

Robin.new().smith()
Robin.new().badass()