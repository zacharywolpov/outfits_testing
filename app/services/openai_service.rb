class OpenaiService
    def initialize
      @client = OpenAI::Client.new
    end
  
    def handle_message(message)
      response = @client.chat(
        parameters: {
          model: 'gpt-4o',
          messages: [{ role: 'user', content: message }],
          temperature: 0.7
        }
      )
      response.dig('choices', 0, 'message', 'content').strip
    rescue StandardError => e
      Rails.logger.error("OpenAI API error: #{e.message}")
      'Sorry, I am having trouble responding at the moment.'
    end
  end