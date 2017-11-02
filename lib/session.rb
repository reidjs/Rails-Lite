require 'json'
require 'pry'
require 'byebug'

class Session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    cookie = req.cookies['_rails_lite_app']
    if cookie
      cookie_vals = JSON.parse(cookie)
      @ivar = cookie_vals
    else
      @ivar = {}
    end
    # binding.pry

    # req
    # req.cookies['_rails_lite_app']
  end

  def [](key)
    @ivar[key]

  end

  def []=(key, val)
    @ivar[key] = val
    # store_session
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    # jsonhash = JSON.generate(@ivar)
    jsonhash = @ivar.to_json
    res.set_cookie('_rails_lite_app', { path: '/', value: jsonhash } )
    # debugger
  end
end
