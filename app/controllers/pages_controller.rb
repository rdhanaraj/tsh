class PagesController < ApplicationController
  before_filter :authenticate_user!

  def home
  end

  def docs
  end
end
