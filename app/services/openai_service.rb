class OpenaiService
    def initialize
      @client = OpenAI::Client.new(
        name: "Outfits Assistant",
        instructions: "You are an outfits assistant. Use your knowledge base to answer questions about outfits and fashion styling.",
        model: 'gpt-4o')
    end
  
    def handle_message(message, outfits_history, closet)
      message += "\n\n\n Use my outfits history below to understand my style and outfit choices. Please use this understanding to answer the above question."
      message += "\n\n\n" + "My outfits history: \n" + outfits_history
      puts message
      response = @client.chat(
        parameters: {
          model: 'gpt-4o',
          messages: [{ role: 'user', content: message }],
          temperature: 0.7
        }
      )
      puts response
      response.dig('choices', 0, 'message', 'content').strip
    rescue StandardError => e
      Rails.logger.error("OpenAI API error: #{e.message}")
      'Sorry, I am having trouble responding at the moment.'
    end

    def generate_embeddings(data)
      response = @client.embeddings.create(
        input: data, model: "text-embedding-3-small"
      )
      puts "Response: " + response
      response['data'].first['embedding']
    rescue StandardError => e
      Rails.logger.error("Error generating embeddings: #{e.message}")
      
    end

  end