# Insert predefined tag to database
PREDEFINED_TAGS = ["privacy", "release", "ethereum"].freeze
PREDEFINED_TAGS.each do |tag_name|
  Tag.create(:tag => tag_name)
  puts "Tag %s is created" % tag_name
end
