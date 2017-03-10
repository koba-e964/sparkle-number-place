#!/usr/bin/env ruby
require "cgi"
cgi = CGI.new
print "Content-Type: text/plain\n\n"
input = cgi["input"]
output = IO.popen("/usr/local/apache2/htdocs/gen-cnf.rb", "r+") {|io|
  io.puts(input)
  io.close_write
  io.readlines.join("")
}
puts output
