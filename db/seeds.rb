# Insert predefined tag to database
PREDEFINED_TAGS = [
  { name: "privacy", description: "Privacy related links", is_media: false },
  { name: "release", description: "Software releases and announcements", is_media: false },
  { name: "ethereum", description: "Ethereum related links", is_media: false },
  { name: "slide", description: "Link to slide", is_media: true },
  { name: "video", description: "Link to video", is_media: true },
  { name: "pdf", description: "Link to pdf", is_media: true },
  { name: "research", description: "Research project links", is_media: false },
  { name: "web3", description: "Web3 links", is_media: false },
  { name: "dapps", description: "Decentralized apps", is_media: false },
  { name: "show", description: "Show blockchain related projects", is_media: false },
  { name: "practice", description: "Development and business practices", is_media: false },
  { name: "wallet", description: "Wallet", is_media: false },
  { name: "smart-contract", description: "Smart contract related links", is_media: false },
  { name: "solidity", description: "Solidity programming language", is_media: false },
  { name: "person", description: "Stories about particular persons", is_media: false },
  { name: "distsys", description: "Distributed system", is_media: false },
  { name: "networking", description: "Networking related links", is_media: false },
  { name: "database", description: "Databases (SQL, NoSQL)", is_media: false },
  { name: "ai", description: "Artificial Intelligence, Machine Learning", is_media: false },
].freeze

PREDEFINED_TAGS.each do |tag|
  Tag.create(
    :tag => tag[:name],
    :description => tag[:description],
    :is_media => tag[:is_media]
  )
  puts "Tag %s is created" % tag[:name]
end
