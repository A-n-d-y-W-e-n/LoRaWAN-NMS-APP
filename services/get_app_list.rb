# frozen_string_literal: true

# Get the application list of a user from DB
class FindMoviesFromApi
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(url_request)
    Dry.Transaction(container: self) do
      step :validate_url_request
      step :call_api_to_get_movie
      step :retrieve_channel_id
      step :retrieve_movies_result
    end.call(url_request)
  end

  # register :validate_url_request, lambda { |url_request|
  #   if url_request.success?
  #     Right(url_request[:title])
  #   else
  #     message = ErrorFlattener.new(
  #       ValidationError.new(url_request)
  #     ).to_s
  #     Left(Error.new(message))
  #   end
  # }
  #
  # register :call_api_to_get_movie, lambda { |title|
  #   results = HTTP.get("#{MovlogApp.config.MOVLOG_API}/movie?search=#{title.gsub(' ', '+')}/")
  #   if results.status.code == 202 || results.status.code == 200
  #     search_results = { http: results }
  #     Right(search_results)
  #   else
  #     Left(Error.new('Our servers failed - we are investigating!'))
  #   end
  # }
  #
  # register :retrieve_channel_id, lambda { |search_results|
  #   begin
  #     if search_results[:http].status.code == 202
  #       data = JSON.parse(search_results[:http].body.to_s)
  #       search_results[:channel_id] = data['channel_id']
  #     end
  #     Right(search_results)
  #   rescue
  #     Left(Error.new('Our servers failed - we are investigating!'))
  #   end
  # }
  #
  # register :retrieve_movies_result, lambda { |search_results|
  #   begin
  #     if search_results[:http].status.code == 200
  #       search_results[:movies] =  MoviesSearchResultsRepresenter.new(
  #         MoviesSearchResults.new).from_json(search_results[:http].body.to_s)
  #     end
  #     Right(search_results)
  #   rescue
  #     Left(Error.new('Our servers failed - we are investigating!'))
  #   end
  # }
end
