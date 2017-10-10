require '.\rssclient.rb'

client = RSSClient.new
while true
  input_string = gets
  client.run_command(input_string)
end