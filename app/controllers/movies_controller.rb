class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = all_ratings()
    if params[:sort] == 'title'
      @movies = Movie.order('title ASC')
      @hilite_title = true
    elsif params[:sort] == 'release_date'
      @movies = Movie.order('release_date DESC')
      @hilite_date = true
    else
      @movies = Movie.all
    end

    # to save selected boxes
    if params[:ratings] == nil # upon first visit to the site
      @ratings_filter = ['G', 'NC-17', 'PG', 'PG-13', 'R']
    else
      selected_movies = []
      @ratings_filter = params[:ratings].keys
      @ratings_filter.each do |rating|
        selected_movies << Movie.where("rating = '#{rating}'")
        selected_movies.flatten!
      end
      @movies = selected_movies
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
    @movie = Movie.find params[:id]
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

  def all_ratings
    all_ratings = []
    @movies = Movie.all
    @movies.each do |movie|
      all_ratings.push(movie.rating)
    end
    all_ratings.to_set.sort
    # @all_ratings = Movie.select('rating').to_set.sort
  end
end