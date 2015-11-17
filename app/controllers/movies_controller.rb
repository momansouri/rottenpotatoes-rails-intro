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
    if params[:sort_by]
      @sort_by = params[:sort_by]
    end
    if params[:ratings]
      ratings = params[:ratings].keys
    end
    if @sort_by
      if !ratings
        @movies = Movie.order(@sort_by).all
      else
        @movies = Movie.order(@sort_by).where(rating: ratings)
      end
      
      @title_header_css = (@sort_by =='title') ? 'hilite' : ''
      @release_date_header_css = (@sort_by =='release_date') ? 'hilite' : ''
    else
      if !ratings
        @movies = Movie.all
      else
        @movies = Movie.where(rating: ratings)
      end
    end
    @all_ratings = Hash[Movie.ratings.map{|x| [x, ratings ? ratings.include?(x):1]}]
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
