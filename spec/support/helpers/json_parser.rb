module Helpers
  def parse_json(file_path)
    JSON.parse(File.read(file_path)).map(&:with_indifferent_access)
  end
end
