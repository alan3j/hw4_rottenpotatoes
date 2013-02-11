# Addition coverage

# =====================================
When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  case uncheck
  when nil
    rating_list.split(',').each do |rating|
      check("ratings_#{rating.strip}")
    end
  when "un"
    rating_list.split(',').each do |rating|
      uncheck("ratings_#{rating.strip}")
    end
  end
end

# =====================================
Given /^I press Refresh$/ do
  click_button(:ratings_submit)
end

# =====================================
Then /^I should see (all|no) movies with ratings: (.*)$/ do |boo, rating_list|
  rselect = ''
  rating_list.split(',').each do |rating|
    rselect == '' ? (rselect = "rating = '#{rating.strip}'") : (rselect = "#{rselect} OR rating = '#{rating.strip}'")
  end
  t = Movie.find_by_sql("SELECT 'movies'.'title' FROM 'movies' WHERE #{rselect}")
  if boo == 'all'
    t.each do |tt|
      assert(page.has_content?(tt.title), "Expected to see movie title \"#{tt.title}\"")
    end
  else
    t.each do |tt|
      assert(page.has_no_content?(tt.title), "Did not expect to see movie title \"#{tt.title}\"")
    end
  end
end

# =====================================
Given /^I uncheck all ratings$/ do
  @flist = []
  Movie.all_ratings.each do |r|
    box = find(:css, "input[id='ratings_#{r}']")
    box.checked?.to_s == "checked" ? @flist << r : false
    uncheck("ratings_#{r}")
  end
end

# =====================================
Then /^I should see the movies from my last valid filter selection$/ do
  @flist.each do |r|
    box = find(:css, "input[id='ratings_#{r}']")
    assert(box.checked?.to_s == "checked", "Expected a filter cloned from your most recent non-blank selections")
  end
end


# =====================================
Then /^I should see all of the movies$/ do
  t = Movie.find_by_sql("SELECT 'movies'.'title' FROM 'movies'")
  t.each do |tt|
    assert(page.has_link?("More about #{tt.title}"), "Expected to see movie title \"#{tt.title}\"")
  end
end

# =====================================
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert(page.body.index(e1) < page.body.index(e2), "Expected to see movie title \"#{e1}\" before \"#{e2}\"")
end


