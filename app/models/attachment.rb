class Attachment < ApplicationRecord
  belongs_to :attachable, optional: true, polymorphic: true, touch: true

  mount_uploader :file, FileUploader
end
