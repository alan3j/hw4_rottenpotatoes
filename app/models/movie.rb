class Movie < ActiveRecord::Base
  def self.all_ratings ; %w(G PG PG-13 NC-17 R) ; end

  validates :title, :presence => true
  validate  :twothousand  #-- Random custom validator
  validates :release_date, :presence => true
  validate  :released_1930_or_later  #-- Custom validator
  validates :rating, :inclusion => { :in => Movie.all_ratings },
    :unless => :grandfathered?

  
  def twothousand  #-- Don't let the title '2000' in to the collection 
    errors.add(:title, "arbitrarily can not have a title = '2000'") if
      self.title == '2000'
  end

  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
      self.release_date < Date.parse('1 Jan 1930')
  end

  @@grandfathered_date = Date.parse('1 Nov 1968')
  def grandfathered? ; self.release_date <= @@grandfathered_date ; end

end
