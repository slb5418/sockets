require 'socket'      # Sockets are in standard library
require 'net/http'                  # The library we need

def simple_socket()

	hostname = 'localhost'
	port = 2000

	s = TCPSocket.open(hostname, port)

	while line = s.gets   # Read lines from the socket
	  puts line.chop      # And print with platform line terminator
	end
	s.close               # Close the socket when done
end


def simple_server()

	server = TCPServer.open(2000)  # Socket to listen on port 2000
	loop {                         # Servers run forever
	  client = server.accept       # Wait for a client to connect
	  client.puts(Time.now.ctime)  # Send the time to the client
	  client.puts "Closing the connection. Bye!"
	  client.close                 # Disconnect from the client
	}
end

def threaded_server()

	server = TCPServer.open(2000)   # Socket to listen on port 2000
	loop {                          # Servers run forever
	  Thread.start(server.accept) do |client|
	    client.puts(Time.now.ctime) # Send the time to the client
		client.puts "Closing the connection. Bye!"
	    client.close                # Disconnect from the client
	  end
	}
end

def fetch_web_contents()
	host = 'www.tutorialspoint.com'     # The web server
	path = '/index.htm'                 # The file we want 

	http = Net::HTTP.new(host)          # Create a connection
	headers, body = http.get(path)      # Request the file
	if headers.code == "200"            # Check the status code   
	  print body                        
	else                                
	  puts "#{headers.code} #{headers.message}" 
	end
end