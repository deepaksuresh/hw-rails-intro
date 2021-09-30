class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
    
    def ratingInSession
      if session[:ratings].nil?
        false
      else
        true
      end
    end
        
    def sortInSession 
      if session[:sort].nil?
        false
      else
        true 
      end
    end
    
    
  
    def index
      @all_ratings = {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"}
      # session.clear
      if params.has_key?(:sort) && !params[:sort].nil?
        @sort = session[:sort]
        session[:sort] = @sort
      elsif self.sortInSession
        @sort = session[:sort]
      else
        @sort = nil
      end
      
      if params.has_key?(:ratings) && !params[:ratings].nil?
        @ratings = params[:ratings]
        session[:ratings] = @ratings
      elsif self.ratingInSession
        @ratings = session[:ratings]
      else
        @ratings = @all_ratings
      end
      
      @movies = Movie.where(:rating=>@ratings.keys).all.order(@sort)
      # redirect_to movies_path(params)
      # puts "printing params ",params
      # puts @ratings
      # @movies = Movie.all
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end