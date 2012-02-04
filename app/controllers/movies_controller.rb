class MoviesController < ApplicationController
    require 'ruby-debug'
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @@sort_choices = ['title', 'release_date']

    session[:checked] = true and session[:ratings] = Hash[Movie.all_ratings.collect{|x| [x, '1']}] unless session[:checked]
    
    @sort_on = session[:sort_on] = @@sort_choices.include?(params[:sort_on]) ? params[:sort_on] : session[:sort_on]
    @ratings = session[:ratings] = (params[:commit] or params[:ratings]) ? params[:ratings] : session[:ratings]

    redirect_to movies_path(:sort_on => @sort_on, :ratings => @ratings) unless @sort_on == params[:sort_on] and @ratings == params[:ratings]
    
    @ratings or @ratings = Hash.new()
    @all_ratings = Movie.all_ratings
    @movies = Movie.find(:all, :order => @sort_on, :conditions => {:rating => @ratings.keys})
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

end
