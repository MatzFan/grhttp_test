#!/usr/bin/env ruby

require 'json'
require 'em-websocket-client'

class Client

  EM.run do
    conn = EventMachine::WebSocketClient.connect('ws://localhost:8090')

    conn.callback do
      conn.send_msg '{"id":0, "method":"call", "params":[0,"get_chain_id",[]]}'
      conn.send_msg '{"id":1, "method":"call", "params":[0,"get_accounts",[["1.2.0"]]]}'
      conn.send_msg '{"id":2, "method":"call", "params":[0,"info",[]]}'
    end

    conn.errback do |e|
      puts "Got error: #{e}"
    end

    conn.stream do |msg|
      data = JSON.parse(msg.data.to_s)
      puts "ID: #{data['id']}"
      puts "RESULT: #{data['result']}"
      puts "ERROR: #{data['error']}"
      puts
      # conn.close_connection if msg.data == 'done'
    end

    conn.disconnect do
      puts "Disconnected"
      EM::stop_event_loop
    end

  end # of EM loop

end

client = Client.new



# require 'grhttp'

# # client = GRHttp::WSClient.connect 'ws://echo.websocket.org' do |ws|
# client = GRHttp::WSClient.connect 'ws://localhost:8090' do |ws|
#   puts "Received >> #{ws.data}"
#   ws.close if ws.data =~ /^(bye|quit|exit|close)/i
# end

# client << '{"id":1, "method":"call", "params":[0,"get_chain_id",[]]}' # => true

# # client << '{"id":1, "method":"call", "params":[0,"get_accounts",[["1.2.0"]]]}'


# # client << 'Bye'
# sleep 2
# puts 'closed' if client.closed?

# client << 'test' # => false
