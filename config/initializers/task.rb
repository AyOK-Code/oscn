# Override Rake::Task to include global exception handling

binding.pry
if !Rails.env.test?
  module Rake
    class Task
      alias :orig_execute :execute
      def execute(args=nil)
        orig_execute(args)
      rescue Exception => ex
        binding.pry
        raise ex if [Interrupt, SystemExit, SignalException].include?(ex.class)
        Raygun.track_exception(ex)
        raise ex
      end
    end
  end
end