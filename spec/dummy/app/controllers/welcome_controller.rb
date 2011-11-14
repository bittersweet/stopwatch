class WelcomeController < ApplicationController
  def index
  end

  def javascript_test
    headers['Content-Type'] = 'application/x-javascript'
    render :file => "#{Rails.root}/public/javascripts/test.js", :layout => false
  end
end
