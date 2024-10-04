module CaseHtmlValidator
  class ValidateAll < ApplicationService
    def perform()
      path = 'app/services/case_html_validator/expected/'
      Dir.foreach(path) do |county_directory|
        next if county_directory == '.' or county_directory == '..'

        Dir.foreach(path + '/' + county_directory) do |case_directory|
          next if case_directory == '.' or case_directory == '..'

          Validate.perform(county_directory, case_directory, from_fixture: false)
        end
      end
    end
  end
end