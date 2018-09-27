class MoviesController < ApplicationController

  @@sortedMovieList = nil

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    sort = params[:sort_list]
    @selected_ratings = params[:ratings] || {}
    
    if @@sortedMovieList != nil
      if sort == nil # check the ratings of the current movie list
        @movies = @@sortedMovieList.where("rating in (?)", @selected_ratings.keys)
        
      else # make a new sort of the database
        @movies = @selected_ratings.empty? ? Movie.all : Movie.where("rating in (?)", @selected_ratings.keys)
      end
    else
      @movies = @selected_ratings.empty? ? Movie.all : Movie.where("rating in (?)", @selected_ratings.keys)
    end
                                                              #@selected_ratings = params[:ratings] || {}
                                                              #@movies = @selected_ratings.empty? ? Movie.all : Movie.where("rating in (?)", @selected_ratings.keys)
    
    doMySort(sort)
    
    
    if @selected_ratings == {} # if nothing selected, check all ratings
       @selected_ratings = {"G" => "1", "PG" => "1", "PG-13" => "1", "R" => "1"}
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy # built in function, a ruby function
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

private

  def doMySort(sort)
    if sort == 'title' || sort == 'release_date'
      @movies = @movies.order(sort)
      @@sortedMovieList = @movies
    end
    
    if sort == 'title'
      @title_header = 'hilite'
    elsif sort == 'release_date'
      @release_date_header = 'hilite'
    end
    
  end

end
