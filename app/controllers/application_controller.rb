class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  def profile(prefix = "profile")
      result = RubyProf.profile { yield }

      dir = File.join(Rails.root, "tmp", "performance", params[:controller].parameterize)
      FileUtils.mkdir_p(dir)
      file = File.join(dir, "callgrind.%s.%s.%s" % [prefix.parameterize, params[:action].parameterize, Time.now.to_s.parameterize] )
      open(file, "w") {|f| RubyProf::CallTreePrinter.new(result).print(f, :min_percent => 1) }
  end

  helper :students
  helper :epitech_modules
  helper_method :profile
end
