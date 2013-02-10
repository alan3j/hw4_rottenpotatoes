Given /^the following movies exist:$/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create! movie
  end
  assert(movies_table.rows.count == Movie.count, "Required movies may not exist") 
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  Movie.where(:title => arg1).first == arg2
end

