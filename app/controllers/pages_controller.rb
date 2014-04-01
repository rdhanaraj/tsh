class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:home]
  def docs
  end

  def index
  end
end
