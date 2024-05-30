class ApplicationService
  def self.perform(*args, **kwargs, &)
    new(*args, **kwargs, &).perform
  end
end
