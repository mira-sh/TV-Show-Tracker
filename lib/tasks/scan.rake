require 'rake'

task :scan => :environment do
	require "#{Rails.root}\\app\\models\\tvmaze"
    api = UrlApi.new 
	Show.all.each do |show|
		last_show_in_db = show.episodes.last
		puts "***************"
		puts "show:" + show.name
		puts "last show in db is from " + last_show_in_db.airdate
		# get episode list from tvmaze
		episodesList = api.allEpisode(show.id.to_s)

		episodesList.each do |episode|

	
			if  episode['airdate'] >= last_show_in_db.airdate && episode['number'] > last_show_in_db.number
				
				# a new episode was released- add it to DB
				@newEpisode = show.episodes.build
				@newEpisode.name = episode['name']
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
				puts  "scan added new episode from " + episode['airdate']
						
			else
				begin					
					db_episode= show.episodes.find(Integer(episode['id']))
				rescue ActiveRecord::RecordNotFound
					puts "didn't find the episode"
				else
					if db_episode.summary != episode['summary']
						db_episode.summary = episode['summary']
						db_episode.save
						puts "updated summary for " + episode['id'].to_s
					end
				end

			end
		end
	end			

end