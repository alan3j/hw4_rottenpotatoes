require 'spec_helper'

describe MoviesController do
  describe 'find movies with same director' do

    it 'should call the model method that finds movies by the given director' do
      @movie1 = FactoryGirl.create(:movie, :id => '1', :title => 'Milk1', :rating => 'PG')
      @movie2 = FactoryGirl.create(:movie, :id => '2', :title => 'Milk2', :rating => 'R')
      @fake_results = [@movie1, @movie2]
      Movie.should_receive(:find_movie).with('1')
      get :find_movie, {:id => '1'}
    end

    it 'should select the Similar Movies template for rendering' do
      @movie1 = FactoryGirl.create(:movie, :id => '1', :title => 'Milk1', :director => 'foo')
      @movie2 = FactoryGirl.create(:movie, :id => '2', :title => 'Milk2', :director => 'foo')
      @fake_results = [@movie1, @movie2]
      Movie.stub(:find_movie).and_return(@fake_results)
      get :find_movie, {:id => '2'}
      response.should render_template('find_movie')
    end

    it 'should make the movie search results available to that template' do
      @movie1 = FactoryGirl.create(:movie, :id => '1', :title => 'Milk1', :director => 'foo')
      @movie2 = FactoryGirl.create(:movie, :id => '2', :title => 'Milk2', :director => 'foo')
      @fake_results = [@movie1, @movie2]
      Movie.stub(:find_movie).and_return(@fake_results)
      get :find_movie, {:id => '2'}
      assigns(:movies).should == @fake_results
    end

    it 'should go to the All Movies page if no director is assigned to the selected movie' do
      @movie1 = FactoryGirl.create(:movie, :id => '1', :title => 'Milk1', :director => '')
      @movie2 = FactoryGirl.create(:movie, :id => '2', :title => 'Milk2', :director => '')
      @fake_results = [@movie1, @movie2]
      Movie.stub(:find_movie).and_return(@fake_results)
      get :find_movie, {:id => '2'}
      response.should redirect_to('/movies')
    end

  end

  describe 'add and remove movies' do

    it 'should add new movies to the database' do
      post :create, :movie => {:title => 'One Movie', :rating => 'G', :release_date => 1.year.ago}
      assert_equal Movie.all.count, 1
      post :create, :movie => {:title => 'Two Movies', :rating => 'G', :release_date => 2.years.ago}
      assert_equal Movie.all.count, 2
    end

    it 'should delete movies from the database' do
      post :create, :movie => {:title => 'One Movie', :rating => 'G', :release_date => 1.year.ago}
      post :create, :movie => {:title => 'Two Movies', :rating => 'G', :release_date => 2.years.ago}
      assert_equal Movie.all.count, 2
      Movie.all.each do |m|
        delete :destroy, id: m.id
      end
      assert_equal Movie.all.count, 0
    end

  end
end

