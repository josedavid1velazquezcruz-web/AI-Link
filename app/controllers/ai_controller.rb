class AiController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def analyze_image
    uploaded_file = params[:image]

    if uploaded_file.blank?
      @image_result = "Debes subir una imagen."
      render :index
      return
    end

    image_bytes = uploaded_file.read

    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(image_bytes),
      filename: uploaded_file.original_filename,
      content_type: uploaded_file.content_type
    )

    uploaded_file.rewind

enhanced_file = HaruImageEnhancerService.enhance(uploaded_file)
enhanced_file.rewind

@ai_provider = "Gemini"
@ai_analysis = HaruGeminiService.analyze_image(enhanced_file)

if @ai_analysis["category"] == "Error" || @ai_analysis["name"].to_s.include?("Error")
  Rails.logger.info "Gemini falló. Haru intentará con ChatGPT."

  enhanced_file.rewind
  @ai_provider = "ChatGPT"
  @ai_analysis = HaruOpenaiService.analyze_image(enhanced_file)
end

    Rails.logger.info "========== HARU =========="
    Rails.logger.info @ai_analysis.inspect
    Rails.logger.info "=========================="

    @generated_title = @ai_analysis["name"]
    @generated_description = @ai_analysis["description"]
    @generated_price = @ai_analysis["price"]
    @generated_quantity = @ai_analysis["quantity"]
    @generated_category = @ai_analysis["category"]
    @generated_marketing_text = @ai_analysis["marketing_text"]
    @image_blob_signed_id = blob.signed_id

    @image_result = "Producto preparado correctamente. Puedes exportarlo al inventario."

    render :index
  end

  def export_product
    product = current_user.products.create(
      name: params[:name],
      description: params[:description],
      price: params[:price],
      quantity: params[:quantity]
    )

    if params[:image_blob_signed_id].present?
      product.image.attach(params[:image_blob_signed_id])
    end

    redirect_to "/inventory/index"
  end
end