require "httparty"
require "base64"

class HaruGeminiService

  def self.analyze_image(uploaded_file)
    new.analyze_image(uploaded_file)
  end

  def analyze_image(uploaded_file)

    image_data = Base64.strict_encode64(uploaded_file.read)

    response = HTTParty.post(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=#{ENV['GEMINI_API_KEY']}",
      headers: {
        "Content-Type" => "application/json"
      },
      body: {
        contents: [
          {
            parts: [
              {
                text: <<~PROMPT
                  Analiza esta imagen.

                  Responde en español.

                  Detecta:

                  - Nombre del producto
                  - Categoría
                  - Colores principales
                  - Descripción comercial
                  - Precio sugerido
                  - Idea de campaña para marketing

                  Responde como Haru.
                PROMPT
              },
              {
                inline_data: {
                  mime_type: uploaded_file.content_type,
                  data: image_data
                }
              }
            ]
          }
        ]
      }.to_json
    )

    json = JSON.parse(response.body)

    json.dig(
      "candidates",
      0,
      "content",
      "parts",
      0,
      "text"
    )

  rescue => e
    "Error Gemini: #{e.message}"
  end

end