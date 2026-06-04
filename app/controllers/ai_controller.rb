class AiController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def analyze_image
    uploaded_file = params[:image]
    name = ""
description = ""
price = 0
quantity = 1

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

# AGREGAR ESTA LINEA
uploaded_file.rewind

@generated_title = name

uploaded_file.rewind

@ai_analysis =
  HaruGeminiService.analyze_image(
    uploaded_file
  )

Rails.logger.info "========== HARU =========="
Rails.logger.info @ai_analysis.inspect
Rails.logger.info "=========================="
@generated_description = @ai_analysis
  @generated_price = price
    @generated_quantity = quantity
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