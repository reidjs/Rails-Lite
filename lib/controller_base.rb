require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'pry'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response ? true : false
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Double render error" if already_built_response?

    @res.header['Location'] = url
    @res.status = 302
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    # @res['Content_type'] = content_type
    raise "Double render error" if already_built_response?

    @res['Content-Type'] = content_type
    # @res.body = ["Hello World #{content}"]
    @res.write("Hello world #{content}")
    @already_built_response = true

    # @res['Content_Type'] = content_type
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    #convert controller class to snakecase
    # p template
    # binding.pry
    controller = self.class.to_s.underscore
    template = "/#{template_name.to_s}.html.erb"
    # controller = @req.path[1..-1] + "_controller"
    path = "views/" +
            controller +
            template
    f = File.read(path)
    binding.pry
    result = ERB.new(f).result(binding)
    render_content(result, "text/html")
    # binding.pry
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
