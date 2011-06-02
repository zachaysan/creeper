require "pp"
require "httparty"
require "json"

class Creepy
  def initialize 
    @creepy = {}

    @known_screen_names = {}
    @known_id_strs = {}

    @TWITTER_API = "http://api.twitter.com/"
    @USERS = @TWITTER_API + "users/lookup.json?"
    @FOLLOWERS = @TWITTER_API + "followers/ids.json?"
    @FRIENDS = @TWITTER_API + "friends/ids.json?"
    @TWEETS = @TWITTER_API + "/statuses/user_timeline.json?"
  end
  def followers(options = {})
    HTTParty.get @FOLLOWERS + find_by(options)
  end
  def users(options = {})
    HTTParty.get @USERS + find_by(options)
  end
  def friends(options = {})
    HTTParty.get @FRIENDS + find_by(options)
  end
  def tweets(options = {})
    HTTParty.get @TWEETS + find_by(options) + "&trim_user=1" + "&count=200"
  end
  def get_userid(screen_name)
    screen_name = screen_name[:screen_name] if screen_name.is_a? Hash
    if @known_screen_names[screen_name].nil?
      @known_screen_names[screen_name] = users(:screen_name => screen_name)
    end
    @known_screen_names[screen_name]["id_str"]
  end
  def get_screen_name(id_str)
    id_str = id_str[:id_str] if id_str.is_a? Hash
    if @known_id_strs[id_str].nil?
      @known_id_strs[id_str] = users(:id_str => id_str)
    end
    @known_id_strs[id_str]["screen_name"]
  end
  protected
  
  def find_by(options = {})
    unless options[:id_str].nil?
      input = options[:id_str]
    else
      input = options[:screen_name]
    end
    if input.is_a? Array
      input = input.join(",")
    elsif input.is_a? Integer
      input = input.to_s
    end
    unless options[:id_str].nil?
      return "user_id=" + input
    else 
      return "screen_name=" + input
    end
  end
end


#pp Creepy.new.users(:ids => 2353)
#pp Creepy.new.friends("zachaysan")
#pp Creepy.new.followers("zachaysan")
pp Creepy.new.get_userid(:screen_name => "zachaysan")
pp Creepy.new.get_screen_name(:id_str => "18900952")

#a = JSON.parse(resp)
#pp a.size
#pp a[0]

#pp h.class
