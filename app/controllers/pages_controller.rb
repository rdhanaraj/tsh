class PagesController < ApplicationController
  before_filter :authenticate_user!, only: [:home]

  def home
  end

  def docs
  end

  def index
  end
end
