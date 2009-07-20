#!/usr/bin/env ruby

dir = File.expand_path(File.dirname(__FILE__))

$LOAD_PATH.unshift("#{dir}/")
$LOAD_PATH.unshift("#{dir}/../lib")

require 'hagbard'

hex = Hagbard::HexaGram.new
puts hex.to_s
puts hex.name + "\s" +  hex.to_bin

puts "\nBecomes:\n\n"

hex.change!
puts hex.to_s
puts hex.name + "\s" +  hex.to_bin
