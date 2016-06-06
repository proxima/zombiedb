require "sinatra"
require "sinatra/activerecord"

set :root, File.join(File.dirname(__FILE__), 'app')
set :views, Proc.new { File.join(root, "views") } 

Dir["app/models/*.rb"].each do |f|
  puts "Loading model: #{f}"
  require_relative f
end

set :database, "sqlite3:///zombie.db"
set :port, 5000

get "/" do
  erb :"index"
end

#get "/sectors/:id.json" do
#  content_type :json
#  Sector.find(params[:id]).to_json(:include => :exits)
#end

#get "/players/new" do
#  @races = Race.find(:all)
#  erb :"players/new"
#end

#post "/players/new" do
#  @player = Player.new(params[:player])
#  if @player.save
#    redirect "/"
#  else
#    @races = Race.find(:all)
#    erb :"players/new"
#  end
#end

helpers do
  def title
    "Zombiemud - zAPI"
  end
end 
