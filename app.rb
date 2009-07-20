dir = File.expand_path(File.dirname(__FILE__))

$LOAD_PATH.unshift("#{dir}/")
$LOAD_PATH.unshift("#{dir}/lib")

require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'hagbard'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get '/' do
  haml :index
end

get '/main.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass :main
end

get '/hex' do
  @chessboard = [
    (1..8).to_a,
    (9..16).to_a,
    (17..24).to_a,
    (25..32).to_a,
    (33..40).to_a,
    (41..48).to_a,
    (49..56).to_a,
    (57..64).to_a
  ]
  haml :browse
end

post '/reading' do 
  before = Hagbard::HexaGram.new
  after = Marshal.load(Marshal.dump(before))
  after.change!
  @question = params[:question]
  @hexes = [ before, after ]
  haml :reading
end 

get '/hex/:name' do |n|
  if n.to_i >= 1 and n.to_i <= 64
    haml :"hex/#{n}"
  else
    not_found "Hexagram #{n} does not exist, pick one from 1 to 64"
  end
end 
