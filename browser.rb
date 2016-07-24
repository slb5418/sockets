require 'socket'
require 'json'

host = 'localhost'        # The web server
port = 2000               # Default HTTP port
path = "/index.html"      # The file we want 

# Get the HTTP request
puts "What type of request would you like to send?"
method = gets.chomp()

if method.upcase() == "POST"
	puts "Enrolling the viking"
	puts "what is the name?"
	name = gets.chomp()
	puts "What is the email?"
	email = gets.chomp()
	viking = {:viking => {:name=>name, :email=>email}}
	content = viking.to_json
	request = "POST #{viking} HTTP/1.0\r\nContent-length: #{viking.to_json.length()}\r\n\r\n#{content}"
	
elsif method.upcase() == "GET"
	request = "GET #{path} HTTP/1.0\r\n\r\n"
end

socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2) 
print body                          # And display it

