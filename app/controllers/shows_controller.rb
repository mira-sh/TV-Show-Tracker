require 'tvmaze'

class ShowsController < ApplicationController
	def index
		@shows = Show.all
	end
	
	def show
		@show = Show.find(params[:id])
		@numberOfSeasons = @show.episodes.maximum(:season)
		
		@season_episode_list = []
		
		#list of lists: each index contains all the episodes in that season
		for i in 1..@numberOfSeasons
			@season_episode_list[i-1] = @show.episodes.where("season = '#{i}'")
		end
	end
	
	
	def new
		@show = Show.new
	end
    
	
	def create
		newShowId = params["show_id"]
		if Show.find_by id: newShowId
			  redirect_to shows_path
		end
		puts "***********************************"
		puts newShowId
		@newShow = Show.new
		
		api = UrlApi.new
		tvmaze_result= api.findShow(newShowId)
		puts tvmaze_result
		@newShow.id = tvmaze_result['id']
		@newShow.name = tvmaze_result['name']
		@newShow.description =tvmaze_result['summary']
		@newShow.image = tvmaze_result['image']['medium']
		
		if  tvmaze_result['status'] == "Running"
			@newShow.running = true
		else
			@newShow.running = false
		end
		@newShow.save
		
		#add all the episodes to the DB
		episodesList = api.allEpisode(newShowId)
		episodesList.each do |episode|
			@newEpisode = @newShow.episodes.build
			
			@newEpisode.name = episode['name']
			@newEpisode.id = episode['id']
			@newEpisode.season = episode['season']	
			@newEpisode.number = episode['number']
			begin 
				DateTime.strptime(episode['airdate'],'%Y-%m-%d').strftime('%v')
			rescue ArgumentError
					@newEpisode.airdate = nil
			else
					@newEpisode.airdate = episode['airdate']
			end
			@newEpisode.airdate = episode['airdate']
			@newEpisode.summary = episode['summary']
			
			@newEpisode.save
		end
		
		@episodes_count = @newShow.episodes.count
		
		puts @episodes_count
		
		redirect_to shows_path
	end	


  def search
	searchTerm =  params["query"]
	puts "the search term is " + params["query"]
	@shows = []
	
	api = UrlApi.new
	tvmaze_result= api.searchShow(searchTerm)
	
#	puts tvmaze_result

	if tvmaze_result != nil
		tvmaze_result.each do |result|
			id = result['show']['id']
			name = result['show']['name']
			description =result['show']['summary']
			
			if result['show']['image'] != nil
				image = result['show']['image']['medium']
			else
				image = nil
			end

			resultShow = Show.new
			resultShow.id = id
			resultShow.name = name
			resultShow.description = description
			resultShow.image = image
			
#TODO- mark if the show is already tracked
			dbshow = Show.find_by id: resultShow.id
			if dbshow != nil
				if dbshow.id == resultShow.id
					resultShow.id = -1
				end
			end
			@shows << resultShow			
	#		episode_result =  api.searchEpisode(result['show']['_links']['nextepisode']['href'])
	#		puts episode_result
			
		end
	end
#	get the shows from tv maze
#	for each result
#	convert into show object
#	add the show object into the list
  end
	
def destroy
  @show = Show.find(params[:id])
  @show.episodes.each do |episode|
	episode.destroy
  end
  @show.destroy
  redirect_to shows_path
end

private
  def show_params
    params.require(:show).permit(:name, :description, :image, :lastAirDate)
  end
  

end



