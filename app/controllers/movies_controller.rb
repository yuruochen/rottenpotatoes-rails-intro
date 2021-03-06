class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    redirect = false
    if !session.has_key? :ratings
	Movie.all_ratings.each do |ra|
            (session[:ratings] ||= { })[ra] = 1
        end
    end
    if params[:ratings]       
        @ratings = params[:ratings]
    elsif session[:ratings]
	@ratings = session[:ratings]
	redirect = true   
    end
    if params[:sort]
	@sort = params[:sort]
    elsif session[:sort]
	@sort = session[:sort]
	redirect = true
    end      
    @movies = Movie.where(rating: @ratings.keys) 
    if @sort == 'title'
       @movies = @movies.where(rating: @ratings.keys).order('title ASC')
       @title_hilite = 'hilite'
    elsif @sort == 'date'
       @movies = @movies.where(rating: @ratings.keys).order('release_date ASC')
       @release_date_hilite = 'hilite'
    end
    if redirect
       redirect_to movies_path(:sort => @sort, :ratings => @ratings)
    end
       session[:sort] = @sort
       session[:ratings] = @ratings
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
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
