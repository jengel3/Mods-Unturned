# encoding: utf-8

class UploadUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "#{Rails.root}/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(zip rar tar)
  end

  def truncated_name
    file.filename[0, 7] + "..." + file.filename[-8, 8] if file.filename.length > 16
  end

  def download_size
    if self.size
      size = self.size / 1000000
      type = "mb"
      if size < 1
        size = self.size / 1000
        type = "kb"
      end
      return size, type
    else
      return 0, "kb"
    end
  end
end
