require "openai"
require "base64"

class HaruAiService
  def self.analyze_image(uploaded_file, name:, description:)
    new.analyze_image(uploaded_file, name: name, description: description)
  end

  def analyze_image(uploaded_file, name:, description:)
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])

    image_data = Base64.strict_encode64(uploaded_file.read)
    content_type = uploaded_file.content_type

    prompt = <<~PROMPT
      Eres Haru, asistente de marketing digital de AI-Link.

      Analiza esta imagen de producto y responde en español de México.

      Datos dados por el usuario:
      Nombre: #{name}
      Descripción: #{description}

      Devuelve una respuesta clara con:
      1. Objeto o producto detectado
      2. Categoría del producto
      3. Colores principales
      4. Descripción mejorada para inventario
      5. Anuncio corto para redes sociales
      6. Idea de campaña
    PROMPT

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          {
            role: "user",
            content: [
              {
                type: "text",
                text: prompt
              },
              {
                type: "image_url",
                image_url: {
                  url: "data:#{content_type};base64,#{image_data}"
                }
              }
            ]
          }
        ],
        max_tokens: 700
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue StandardError => e
    "Haru no pudo analizar la imagen con IA en este momento. Error: #{e.message}"
  end
end