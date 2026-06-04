require "faraday"
require "json"
require "base64"

class HaruGeminiService
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent"

  def self.analyze_image(image)
    new.analyze_image(image)
  end

  def analyze_image(image)
    image_data = Base64.strict_encode64(image.read)

    prompt = <<~PROMPT
      Eres Haru, asistente de AI-Link Marketing Suite.

      Analiza la imagen y detecta si contiene un producto.

      Responde SOLO en JSON válido con este formato:

      {
        "name": "nombre del producto",
        "description": "descripción breve",
        "price": 0,
        "quantity": 1,
        "category": "categoría",
        "marketing_text": "texto promocional corto"
      }

      Si no puedes detectar el producto, usa:
      {
        "name": "Producto no identificado",
        "description": "No pude identificar claramente el producto en la imagen.",
        "price": 0,
        "quantity": 1,
        "category": "Sin categoría",
        "marketing_text": "Sube una imagen más clara para ayudarte mejor."
      }
    PROMPT

    response = Faraday.post("#{API_URL}?key=#{ENV["GEMINI_API_KEY"]}") do |req|
      req.headers["Content-Type"] = "application/json"
      req.body = {
        contents: [
          {
            parts: [
              { text: prompt },
              {
                inline_data: {
                  mime_type: image.content_type,
                  data: image_data
                }
              }
            ]
          }
        ]
      }.to_json
    end

    data = JSON.parse(response.body)

Rails.logger.info "===== GEMINI RAW RESPONSE ====="
Rails.logger.info data.inspect
Rails.logger.info "==============================="

text = data.dig(
  "candidates",
  0,
  "content",
  "parts",
  0,
  "text"
)

    return {
  "name" => "Respuesta vacía",
  "description" => data.inspect,
  "price" => 0,
  "quantity" => 1,
  "category" => "Debug",
  "marketing_text" => "Gemini no devolvió texto."
} if text.nil?

JSON.parse(
  text.gsub("```json", "")
      .gsub("```", "")
      .strip
)
  rescue => e
    {
      "name" => "Error con Haru",
      "description" => e.message,
      "price" => 0,
      "quantity" => 1,
      "category" => "Error",
      "marketing_text" => "Haru no pudo analizar la imagen."
    }
  end
end