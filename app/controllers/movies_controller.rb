class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    # @session = session
  end

  def index
    # @session = session.clear
    @session = session
    @all_ratings = all_ratings() # sets checkboxes in index.html.haml

    unless @session[:ratings] # if new session
      @session[:ratings] = ratings_hash()
      @movies = Movie.all
      @ratings_filter = @session[:ratings].keys
    else
      if params[:sort] # controls title and release_date sort
        @session[:sort] = params[:sort]
      end
      @movies = display_movies(@session)
      # if params[:sort] == 'title'
      if @session[:sort] == 'title'
        @hilite_title = true
      elsif @session[:sort] == 'release_date'
      # elsif params[:sort] == 'release_date'
        @hilite_date = true
      end

      if params[:ratings]
      # if params[:ratings] || @session[:ratings]
        selected_movies = []
        @session[:ratings] = params[:ratings]
        @ratings_filter = @session[:ratings].keys
        @movies = display_movies(@session)
      else
        @ratings_filter = @session[:ratings].keys
      end
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find(params[:id])
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def all_ratings # gets all ratings in array in the entire movie model
    ratings_hash.keys.sort
    # all_ratings = []
    # @movies = Movie.all
    # @movies.each do |movie|
    #   all_ratings.push(movie.rating)
    # end
    # all_ratings.to_set.sort
    # # @all_ratings = Movie.select('rating').to_set.sort
  end

  def display_movies(param_h = {})
    if param_h[:sort] && param_h[:ratings]
      ratings_filter = param_h[:ratings].keys
      @movies = Movie.order(param_h[:sort] + ' ASC').where(rating: ratings_filter)
    elsif param_h[:sort]
      @movies = Movie.order(param_h[:sort] + ' ASC')
    elsif param_h[:ratings]
      ratings_filter = param_h[:ratings].keys
      @movies = Movie.where(rating: ratings_filter)
    else
      @movies = Movie.all
    end
  end

  def ratings_hash # returns hash of ratings in Movie model
    ratings_hash = {}
    Movie.find_each do |movie|
      ratings_hash[movie.rating] = 1
    end
    return ratings_hash
  end
end