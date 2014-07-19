class Document
  def add_authors( names )
    author = ""
    author += "#{names.join(' ')}"
    puts author
  end
end

Document.new().add_authors(["robin", "smith"])