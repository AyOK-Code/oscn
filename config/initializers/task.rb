# Override Rake::Task to include global exception handling

if !Rails.env.test?
  module Rake
    class Task
      alias :orig_execute :execute
      def execute(args=nil)
        orig_execute(args)
      rescue Exception => ex
        raise ex if [Interrupt, SystemExit, SignalException].include?(ex.class)
        Raygun.track_exception(ex)
        raise ex
      end
    end
  end
end