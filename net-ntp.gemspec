# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'net/ntp/version'

Gem::Specification.new do |s|
  s.name        = "net-ntp"
  s.version     = Net::NTP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jerome Waibel", "Nathan Sutton", "Brandon Arbini"]
  s.email       = ["nate@zencoder.com", "brandon@zencoder.com"]
  s.homepage    = "http://github.com/zencoder/net-ntp"
  s.summary     = "NTP client for ruby."
  s.description = "This project was a rubyfied version of perl's Net::NTP module, (C) 2004 by James G. Willmore. It provides a method to query an NTP server as specified in RFC1305 and RFC2030. Updated and re-released in 2010 by Zencoder."
  s.files        = Dir.glob("lib/**/*") + %w(LICENSE README.markdown Rakefile)
  s.require_path = "lib"
end
