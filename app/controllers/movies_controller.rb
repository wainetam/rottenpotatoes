class MoviesController < ApplicationController
  # session: on # creates session hash

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session.clear

    # unless params[:sort] and params[:ratings] == nil
      
    # else 
    #   @movies = Movie.all
    #   @ratings_filter = ['G', 'NC-17', 'PG', 'PG-13', 'R'] # shows all checkboxes checked

    # if params[:sort] and params[:ratings] == nil
    #   @movies = Movie.all
    # elsif session[:sort]
    #   params[:sort] = session[:sort]
    #   if params[:sort] == 'title'
    #     @movies = Movie.order('title ASC') # where("rating = 'R'") 
    #     # @movies = Movie.order('title ASC').where
    #     @hilite_title = true
    #     # session.delete[:sort]
    #     session[:sort] = 'title'
    #   elsif params[:sort] == 'release_date'
    #     @movies = Movie.order('release_date DESC') 
    #     @hilite_date = true
    #     # session.delete[:sort]
    #     session[:sort] = 'release_date'

    @all_ratings = all_ratings() # sets checkboxes in index.html.haml

    unless params[:sort]
      session[:sort] ? params[:sort] = session[:sort] : @movies = Movie.all
    end

    if params[:sort]
      # @movies = Movie.order(params[:sort] + ' ASC').where(session[:ratings] ? 'rating: #{session[:ratings].keys}' : "")
      @movies = Movie.order(params[:sort] + ' ASC')
      session[:sort] = params[:sort]
      if params[:sort] == 'title'
        @hilite_title = true
      elsif params[:sort] == 'release_date'
        @hilite_date = true
      end
    else
      @movies
    end

    #   @all_ratings = all_ratings()
    # if params[:sort] == 'title'
    #   # @movies = Movie.order('title ASC') # where("rating = 'R'")
    #   @movies = Movie.order(params[:sort] + ' ASC') # where("rating = 'R'")
    #   @hilite_title = true
    #   # session.delete[:sort]
    #   session[:sort] = params[:sort]
    # elsif params[:sort] == 'release_date'
    #   @movies = Movie.order(params[:sort] + ' ASC') 
    #   @hilite_date = true
    #   # session.delete[:sort]
    #   session[:sort] = params[:sort]
    # else
    #   # session[:sort] ? params[:sort] = session[:sort] : @movies = Movie.all
    #   # @movies = Movie.all
    #   @movies
    #   # session[:filtered_movies] = @movies
    # end

    unless params[:ratings]
      session[:ratings] ? params[:ratings] = session[:ratings] : @movies
    end

    if params[:ratings]
      selected_movies = []
      session[:ratings] = params[:ratings]
      @ratings_filter = params[:ratings].keys
      @movies = Movie.where(rating: @ratings_filter)
      # @ratings_filter.each do |rating|
      #   selected_movies << Movie.where('rating = ?', rating) 
      #   selected_movies.flatten!
      # end
      # @movies = selected_movies
    else
      @ratings_filter = ['G', 'NC-17', 'PG', 'PG-13', 'R'] # shows all checkboxes checked if no params[:ratings]
    end
  end
    # else
    #   selected_movies = []
    #   session[:ratings] = params[:ratings]
    #   @ratings_filter = params[:ratings].keys
    #   @ratings_filter.each do |rating|
    #     selected_movies << Movie.where("rating = '#{rating}'") 
    #     selected_movies.flatten!
    #   end
    #   @movies = selected_movies
    # end




    # to save selected boxes
    # if params[:ratings] == nil # upon first visit to the site
    #   @ratings_filter = ['G', 'NC-17', 'PG', 'PG-13', 'R'] # shows all checkboxes checked
    #   # session[:ratings] = nil
    # else
    #   selected_movies = []
    #   session[:ratings] = params[:ratings]
    #   @ratings_filter = params[:ratings].keys
    #   @ratings_filter.each do |rating|
    #     selected_movies << Movie.where("rating = '#{rating}'") 
    #     selected_movies.flatten!
    #   end
    #   @movies = selected_movies
    # end
    # session[:filtered_movies] = @movies
  # end

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