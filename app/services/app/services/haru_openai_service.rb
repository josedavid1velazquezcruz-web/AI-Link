require "faraday"
require "json"
require "base64"

class HaruOpenaiService
  API_URL = "https://api.openai.com/v1/responses"

  def self.analyze_image(image)
    new.analyze_image(image)
  end

  def analyze_image(image)
    image_data = Base64.strict_encode64(image.read)

    prompt = <<~PROMPT
      Eres Haru, asistente de AI-Link Marketing Suite.

      Analiza la imagen y detecta si contiene un producto.

      Responde SOLO en JSON válido:
      {
        "name": "nombre del producto",
        "description": "descripción breve",
        "price": 0,
        "quantity": 1,
        "category": "categoría",
        "marketing_text": "texto promocional corto"
      }
    PROMPT

    response = Faraday.post(API_URL) do |req|
      req.headers["Content-Type"] = "application/json"
      req.headers["Authorization"] = "Bearer #{ENV["OPENAI_API_KEY"]}"

      req.body = {
        model: "gpt-5.5-mini",
        input: [
          {
            role: "user",
            content: [
              { type: "input_text", text: prompt },
              {
                type: "input_image",
                image_url: "data:#{image.content_type};base64,#{image_data}"
              }
            ]
          }
        ]
      }.to_json
    end

    data = JSON.parse(response.body)
    text = data.dig("output", 0, "content", 0, "text")

    raise "ChatGPT no devolvió texto: #{data.inspect}" if text.blank?

    JSON.parse(text.gsub("```json", "").gsub("```", "").strip)
  rescue => e
    {
      "name" => "Error con ChatGPT",
      "description" => e.message,
      "price" => 0,
      "quantity" => 1,
      "category" => "Error",
      "marketing_text" => "ChatGPT no pudo analizar la imagen."
    }
  end
end