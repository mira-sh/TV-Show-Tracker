class EpisodesController < ApplicationController
	def index
		@episodes = Episode.all
	end
	
	def mark_as_watched
		  @episode = Episode.find(params["episode_id"])
		  puts @episode
		  if params["watched"] != nil
			@episode.watched = true
		  else
		   @episode.watched = false
		  end
		  @episode.save
		  redirect_to controller: "shows", action: "show", id: params["id"] 
	end
	
	def delete_episode
			@episode = Episode.find(params["episode_id"])
			@episode.destroy
		redirect_to controller: "shows", action: "show", id: params["id"] 
	end
end
