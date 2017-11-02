require 'rack'
require_relative '../lib/controller_base'
require 'pry'
class MyController < ControllerBase
  def go
    # binding.pry
    session["count"] ||= 0
    # binding.pry
    session["count"] += 1
    # binding.pry

    render :counting_show
  end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
