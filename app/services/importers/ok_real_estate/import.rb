module Importers
  module OkRealEstate
    class Import
      def self.perform
        new.perform
      end

      def perform
        import_agents
        import_agent_details
      end

      def import_agents
        puts 'Importing agents...'
        count = Importers::OkRealEstate::Agent.new(10, 0).fetch_count
        take = 1000
        pages = (count / take.to_f).ceil
        bar = ProgressBar.new(pages)
        pages.times do |page|
          bar.increment!
          Importers::OkRealEstate::Agent.perform(take, page * take)
          sleep 1
        end
      end

      def import_agent_details
        puts 'Importing agent details...'
        agents = ::OkRealEstate::Agent.needs_scrape
        count = agents.count
        bar = ProgressBar.new(count)
        agents.each_with_index do |agent, i|
          bar.increment!
          Importers::OkRealEstate::AgentDetail.perform(agent.external_id)
          sleep rand(1..5)
          break if i > 1000
        end
      end
    end
  end
end
