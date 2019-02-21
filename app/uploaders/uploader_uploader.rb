class UploaderUploader < CarrierWave::Uploader::Base
  
  # 이미지를 조정할 수 있는 툴 설정
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # -*- coding: utf-8 -*
  require 'iconv' 

  # 이미지를 저장할 장소의 종류를 설정
  # Choose what kind of storage to use for this uploader:
  # storage :file
  storage :fog

  #이미지가 저장되는 위치
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [1080, nil]
  #process :watermark

  def user_name_width(name)
    str = "a".."z"
    mark = (0..9).to_a + [".", "_", "#"]
    count = []

    str.each do |s|
      count << name.count(s)
    end

    mark.each do |m|
      count << name.count(m.to_s)
    end

    # a..z & 0..9 & ., _, # 38개 문자 width
    width = [20, 21, 19, 21, 21, 13, 20, 20, 7, 9,
             19, 6, 32, 19, 21, 21, 21, 13, 19, 12,
             20, 21, 30, 20, 21, 19, 20, 13, 20, 20,
             20, 21, 19, 20, 18, 20, 7, 24, 24]

    total_width = 0
    for i in 0..37 do
      total_width += count[i] * width[i]
    end

    # 영어, 숫자, 기호가 아닐 경우(한글 넓이 20으로 가정)
    total_width += (name.length - count.sum) * 20

    # 문자 간 여백 "6"
    total_width += ((name.length - 1) * 7)

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
          cmd.draw "text 26,23 'Day #{model.count_day.to_s.rjust(2, "0")}'"
          cmd.pointsize "40"
          cmd.font "Helvetica-Bold"
          cmd.fill "white"
        end

        img.combine_options do |cmd|
          cmd.gravity "southeast"
          cmd.draw "image Over #{user_name_width(user_name) + 20},0 0,0 '#{Rails.root}/app/assets/images/watermark_bottom.png'"
        end

        img.combine_options do |cmd|
          cmd.draw "rectangle #{img.width - user_name_width(user_name) - 20},#{img.height - 80} #{img.width},#{img.height}"
          cmd.fill "rgba(256, 102, 102, 0.85)"
        end

        img.combine_options do |cmd|
          cmd.gravity "southeast"
          cmd.draw "text 23,18 '#{user_name}'"
          cmd.kerning "4"
          cmd.pointsize "40"
          cmd.font "Helvetica-Bold"
          cmd.fill "white"
        end
      else
        img.combine_options do |cmd|
          cmd.gravity "southeast"
          cmd.draw "image Over #{user_name_width(user_name) + 30},0 0,0 '#{Rails.root}/app/assets/images/watermark1.png'"
        end

        img.combine_options do |cmd|
          cmd.draw "rectangle #{img.width - user_name_width(user_name) - 30},#{img.height - 80} #{img.width},#{img.height}"
          cmd.fill "rgba(0, 0, 0, 0.7)"
        end

        img.combine_options do |cmd|
          cmd.gravity "southeast"
          cmd.draw "text 23,18 '#{user_name}'"
          #Iconv.iconv("EUC-KR", "UTF-8", mystring)
          cmd.kerning "4"
          cmd.pointsize "40"
          cmd.font "Helvetica-Bold"
          cmd.fill "white"
        end
      end
    end
  end

  # 요청한 이미지가 없을 때 대체해서 사용하는 default 이미지 설정
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # 이미지를 저장할 사이즈 조정
  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # 여러가지 이미지의 버전 설정
  # Create different versions of your uploaded files:
  # 썸네일 버전
  version :thumb do 
    process resize_to_fit: [50, 50]
  end
  # 워터마크 버전
  version :with_watermark do
    process :watermark
  end

  # 저장될 파일들의 확장자 설정
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
  #   %w(jpg jpeg gif png)
    %w(png)
  end

  # 저장되는 파일의 이름 설정
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
  #  "something.jpg" if original_filename
    if model.filename.present?
      "#{model.filename}.jpg"
    else
      "something.jpg"
    end
    
  end

end
