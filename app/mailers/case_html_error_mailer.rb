class CaseHtmlErrorMailer < ApplicationMailer
  def error_email(errors)
    @errors = errors

    mail(
      to: ENV.fetch('INVALID_CASE_HTML_EMAIL_TO', 'sabrina.leggett@9bcorp.com'),
      cc: ENV.fetch('INVALID_CASE_HTML_EMAIL_CC', 'sabrina.leggett@9bcorp.com').split(','),
      subject: "ERROR PARSING CASE HTML: sections #{errors.map{|x| x[:section]}.join(", ")}",
      reply_to: 'info@arnallfamilyfoundation.org'
    )
  end
end
