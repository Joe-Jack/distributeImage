require 'mysql2'

def droppedToMysql(image, index_id)
  client = Mysql2::Client.new(:host => 'localhost', :username => 'root', :database => 'distributeImage_development', :socket => "/var/lib/mysql/mysql.sock")
  statement = client.prepare('INSERT INTO pictures (pic, index_id) VALUES(?,?)')
  statement.execute("image", "index_id")
end
  # query = %Q{insert into pictures (pic, index_id) values ( ?, ? ) 'sample', 29 }
  # results = client.query(query)
  
  # query = %q{select index_id from pictures}
  # results = client.query(query)
  # results.each do |row|
  #   puts "--------------------"
  #   row.each do |key, value|
  #     puts "#{key} => #{value}"
  #   end
  # end
  # query = %q{select Pic from pictures}
  # results = client.query(query)
  # results.each do |row|
  #   puts "--------------------"
  #   row.each do |key, value|
  #     puts "#{key} => #{value}"
  #   end
  # end