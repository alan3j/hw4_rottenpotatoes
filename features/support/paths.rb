# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    @page_name = page_name
    case page_name

    when /^the home\s?page$/
      '/movies'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    #-- path to first record having a matching title
    when /^the edit page for "(.+)"$/
      @page_name =~ /^the edit page for "(.+)"$/
      m_id = Movie.where(:title => $1).first.id
      "/movies/#{m_id}/edit"

    #-- path to /movies/:id
    when /^the details page for "(.+)"$/
      @page_name =~ /^the details page for "(.+)"$/
      m_id = Movie.where(:title => $1).first.id
      "/movies/#{m_id}"

    #-- path to 
    when /^the Similar Movies page for "(.+)"$/
      "/movies/find_movie"

    #-- Additional coverage
    when /^the (RottenPotatoes )?home\s?page$/ then '/movies'

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
