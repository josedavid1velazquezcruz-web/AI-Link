require "image_processing/vips"

class HaruImageEnhancerService
  def self.enhance(uploaded_file)
    new.enhance(uploaded_file)
  end

  def enhance(uploaded_file)
    processed = ImageProcessing::Vips
      .source(uploaded_file.tempfile.path)
      .resize_to_limit(1200, 1200)
      .sharpen
      .call

    ActionDispatch::Http::UploadedFile.new(
      tempfile: processed,
      filename: uploaded_file.original_filename,
      type: uploaded_file.content_type
    )
  rescue
    uploaded_file
  end
end
