
class UrlApi

	SHOWS_SEARCH_BASE =   'http://api.tvmaze.com/search/shows?q='
	SHOWS_BASE =   'http://api.tvmaze.com/shows/'


	def searchShow(searchTerm)
		puts "------------------------------"
		response = HTTParty.get(SHOWS_SEARCH_BASE + searchTerm)
		# TODO more error checking (500 error, etc)
		json = JSON.parse(response.body)
		return json
	end
  
	def findShow(showID)
		puts "------------------------------"
		response = HTTParty.get(SHOWS_BASE + showID)
		# TODO more error checking (500 error, etc)
		json = JSON.parse(response.body)
		return json
	end
 
	def allEpisode(showID)
		response = HTTParty.get(SHOWS_BASE + showID + "/episodes")
		# TODO more error checking (500 error, etc)
		json = JSON.parse(response.body)
		return json
	end
  
end

