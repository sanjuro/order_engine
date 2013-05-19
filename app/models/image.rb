require File.dirname(__FILE__) +  '/asset.rb'

class Image < Asset
  include Paperclip::Glue

  validates_attachment_presence :attachment
  validate :no_attachment_errors

  attr_accessible :alt, :attachment, :position, :viewable_type, :viewable_id

  has_attached_file :attachment,
                    :styles => { :mini => '36x36>', :little => '56x56>', :small => '100x100>', :large => '600x600>' },
                    :default_style => :small,
                    :url =>  "/:id/:style/:basename.:extension",
                    :path => 'http://m.vosto.co.za/public/:viewable_type/:id/:style/:basename.:extension',
                    :convert_options => { :all => '-strip -auto-orient' }
  # save the w,h of the original image (from which others can be calculated)
  # we need to look at the write-queue for images which have not been saved yet
  after_post_process :find_dimensions

  # include Spree::Core::S3Support
  # supports_s3 :attachment

  # Vosto::Image.attachment_definitions[:attachment][:styles] = ActiveSupport::JSON.decode(Vosto::Config[:attachment_styles])
  # Vosto::Image.attachment_definitions[:attachment][:path] = Vosto::Config[:attachment_path]
  # Vosto::Image.attachment_definitions[:attachment][:url] = Vosto::Config[:attachment_url]
  # Vosto::Image.attachment_definitions[:attachment][:default_url] = Vosto::Config[:attachment_default_url]
  # Vosto::Image.attachment_definitions[:attachment][:default_style] = Vosto::Config[:attachment_default_style]

  #used by admin products autocomplete
  def mini_url
    attachment.url(:mini, false)
  end

  def little_url
    attachment.url(:little, false)
  end

  def small_url
    attachment.url(:small, false)
  end

  def find_dimensions
    temporary = attachment.queued_for_write[:original]
    filename = temporary.path unless temporary.nil?
    filename = attachment.path if filename.blank?
    geometry = Paperclip::Geometry.from_file(filename)
    self.attachment_width  = geometry.width
    self.attachment_height = geometry.height
  end

  # if there are errors from the plugin, then add a more meaningful message
  def no_attachment_errors
    unless attachment.errors.empty?
      # uncomment this to get rid of the less-than-useful interrim messages
      # errors.clear
      errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
      false
    end
  end
  end
