module Helpers
    def parse_json(file_path)
        JSON.parse(File.open(file_path).read).map { |td| td.with_indifferent_access }
    end
end