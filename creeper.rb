require "pp"
require "httparty"
require "json"

class Creepy
  def initialize 
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
    HTTParty.get @TWEETS + find_by(options) + "&trim_user=1"
  end
  
  protected
  
  def find_by(options = {})
    unless options[:ids].nil?
      input = options[:ids]
    else
      input = options[:screen_name]
    end
    if input.is_a? Array
      input = input.join(",")
    elsif input.is_a? Integer
      input = input.to_s
    end
    unless options[:ids].nil?
      return "user_id=" + input
    else 
      return "screen_name=" + input
    end
  end
end


#pp Creepy.new.users(:ids => 2353)
#pp Creepy.new.friends("zachaysan")
#pp Creepy.new.followers("zachaysan")
pp Creepy.new.tweets(:screen_name => "zachaysan")
