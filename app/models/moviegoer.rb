class Moviegoer < ActiveRecord::Base
  attr_protected :uid, :provider, :name
  def self.create_with_omniauth(auth)
    Moviegoer.create!(
      :provider => auth["provider"],
      :uid      => auth["uid"],
      :name     => auth["info"]["name"])
  end
end
