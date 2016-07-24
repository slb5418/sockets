require 'socket'
require 'json'

server = TCPServer.open(2000)   # Socket to listen on port 2000
loop {                          # Servers run forever
  Thread.start(server.accept) do |client|

    # take the HTTP request from the browser
    # parse the incoming request yourself
    methods = ["GET", "POST"]
    request = client.read_nonblock(256)

    request_method = nil
    methods.each do |method|
    	if request.include? method
    		request_method = method
    		break
    	end
    end

    if request_method == "GET"
    	filename = request.split(" ")[1]
    	file = File.basename(filename)
   		if File.exist? (file)
   			response = "HTTP/1.0 200 OK\r\n\r\n"
   		else
   			response = "HTTP/1.0 404 File does not exist"
   		end
   		contents = File.read(file)
   		response += contents

   	elsif request_method == "POST"
   		# content_length = request.scan(/Content-length: (\d+)/)[0][0]
   		content = request.split("\r\n\r\n")[1]
   		parsed = JSON.parse(content)
   		response = "HTTP/1.0 200 OK\r\n\r\n"
   		response += File.read("thanks.html")
   		params = parsed
   		name = params['viking']['name']
   		email = params['viking']['email']
   		list_items = "<li>Name: #{name}</li><li>Email: #{email}</li>"
   		response = response.gsub(/<%= yield %>/, list_items) 
   	end

   	client.puts(response)
    client.puts(Time.now.ctime) # Send the time to the client
	client.puts "Closing the connection. Bye!"
    client.close                # Disconnect from the client
  end
}
