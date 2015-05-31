load 'sql_to_class.rb'

t = SqlToClass.new ARGV[0]
u, r = t.convert(:syntax => :mysql, :connection_string => "Server=localhost;Database=mydb;User ID=user;Password=password;Pooling=false;Convert Zero Datetime=True", :with_insert => true)

puts u + "\n"
r.each do |cr|
  print cr
  puts
end
