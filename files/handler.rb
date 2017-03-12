#!/usr/bin/env ruby
require "cgi"
cgi = CGI.new
print "Content-Type: text/plain\n\n"
input = cgi["input"]
script_dir = File.expand_path(File.dirname($0))
output = IO.popen(script_dir + "/gen-cnf.rb", "r+") {|io|
  io.puts(input)
  io.close_write
  io.readlines.join("")
}
puts output
