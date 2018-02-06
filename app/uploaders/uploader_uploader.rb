class UploaderUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :watermark

  def user_name_width(name)
    str = "a".."z"
    mark = (0..9).to_a + [".", "_"]
    count = []

    str.each do |s|
      count << name.count(s)
    end

    mark.each do |m|
      count << name.count(m.to_s)
    end

    # a..z & 0..9 & ., _ 38개 문자 width
    width = [22, 23, 21, 24, 23, 13, 24, 23, 7, 8,
             21, 7, 34, 22, 25, 23, 23, 14, 22, 13,
             21, 23, 33, 23, 24, 20, 22, 14, 22, 22,
             23, 23, 23, 23, 23, 23, 7, 27]

    total_width = 0
    for i in 0..37 do
      total_width += count[i] * width[i]
    end

    # 문자 간 여백 "3"
    total_width += ((name.length - 1) * 3)

    return total_width
  end

  def watermark
    manipulate! do |img|

      # user id watermark
      if model.user_name.present?
        user_name = model.user_name
      else
        user_name = "FAIL"
      end

      # rocket regram date watermark
      if model.count_day.present?
        img.combine_options do |cmd|
          cmd.gravity "northwest"
          cmd.draw "image Over 0,0 0,0 '#{Rails.root}/app/assets/images/watermark_top.png'"
        end

        img.combine_options do |cmd|
          cmd.gravity "northwest"
          cmd.draw "text 30,25 'Day #{model.count_day.to_s.rjust(2, "0")}'"
          cmd.pointsize "45"
          cmd.font "Helvetica-Bold"
          cmd.fill "white"
        end

        img.combine_options do |cmd|
          cmd.gravity "southeast"
          cmd.draw "image Over #{user_name_width(user_name) + 60},0 0,0 '#{Rails.root}/app/assets/images/watermark_bottom.png'"
        end

        img.combine_options do |cmd|
          cmd.draw "rectangle #{img.width - user_name_width(user_name) - 60},#{img.height - 88} #{img.width},#{img.height}"
          cmd.fill "rgba(256, 102, 102, 0.85)"
        end

        img.combine_options do |cmd|
          cmd.gravity "southeast"
          cmd.draw "text 33,20 '#{user_name}'"
          cmd.pointsize "45"
          cmd.font "Helvetica-Bold"
          cmd.fill "white"
        end
      else
        img.combine_options do |cmd|
          cmd.gravity "southeast"
          cmd.draw "image Over #{user_name_width(user_name) + 60},0 0,0 '#{Rails.root}/app/assets/images/watermark1.png'"
        end

        img.combine_options do |cmd|
          cmd.draw "rectangle #{img.width - user_name_width(user_name) - 60},#{img.height - 88} #{img.width},#{img.height}"
          cmd.fill "rgba(0, 0, 0, 0.7)"
        end

        img.combine_options do |cmd|
          cmd.gravity "southeast"
          cmd.draw "text 33,20 '#{user_name}'"
          cmd.pointsize "45"
          cmd.font "Helvetica-Bold"
          cmd.fill "white"
        end
      end
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:

  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end
  #version :with_watermark do
    #process :watermark
  #end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
