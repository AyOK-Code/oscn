class EvictionsMailer < ApplicationMailer
  def file_email(eviction_file_id, date_range)
    @eviction_file = EvictionFile.find(eviction_file_id)
    @generated_at = @eviction_file.generated_at.in_time_zone('Central Time (US & Canada)')
    @start = date_range[:start]
    @finish = date_range[:finish]

    # Ensure there's a file attached before attempting to attach it
    raise 'No file attached to the EvictionFile' unless @eviction_file.file.attached?

    attachments[@eviction_file.file.filename.to_s] = {
      mime_type: @eviction_file.file.content_type,
      content: @eviction_file.file.download
    }

    @eviction_file.update!(sent_at: Time.zone.now)

    mail(to: ENV.fetch('EVICTIONS_EMAIL', 'hmitchell@9bcorp.com'), subject: "Evictions File ID: #{@eviction_file.id}",
         reply_to: 'info@arnallfamilyfoundation.org')
  end
end