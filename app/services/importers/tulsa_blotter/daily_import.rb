module Importers
  module TulsaBlotter
    class DailyImport < ApplicationService
      def perform
        save_pages
      end

      def save_pages
        page_number = 1
        incarcerated_ids = []
        while (response = page_json(page_number))
          json = JSON.parse(response)
          save_page(json)
          page_number += 1
          incarcerated_ids += (json['Data'].map { |val| val['Booking ID'] })
        end
        track_released(incarcerated_ids)
      end

      def track_released(incarcerated_ids)
        ::TulsaBlotter::Arrest.where(release_date: nil).where.not(booking_id: incarcerated_ids).each do |arrest|
          arrest.update!(release_date: DateTime.now)
        end
      end

      def save_page(json)
        page = ::TulsaBlotter::PageHtml.create!(
          page_number: json['Page Number'],
          html: json['Bookings Html'],
          scraped_at: DateTime.now
        )
        json['Data'].map { |inmate_json| upsert_arrest(inmate_json, page) }
      end

      def upsert_arrest(json, page)
        json = json.merge(json['Arrests'][0])
        arrest = ::TulsaBlotter::Arrest.find_or_initialize_by(booking_id: json['Booking ID'])
        arrest.page_htmls << page
        arrest = arrest_attributes_from_json(arrest, json)
        arrest.save!
        upsert_arrest_detail_html(arrest, json)
        upsert_all_offenses(arrest, json)
        arrest
      end

      def arrest_attributes_from_json(arrest, json)
        arrest.assign_attributes(
          address: json['Address'],
          booking_id: json['Booking ID'],
          city_state_zip: json['City/State/Zip'],
          dlm: json['DLM'],
          eyes: json['Eyes'],
          first: json['First'],
          gender: json['Gender'],
          hair: json['Hair'],
          height: json['Height'],
          last: json['Last'],
          middle: json['Middle'],
          race: json['Race'],
          weight: json['Weight'],
          arrest_date: format_datetime(json['Arrest Date'], json['Arrest Time']),
          arresting_agency: arresting_agency(json['Arrested By']),
          arrested_by: arresting_officer(json['Arrested By']),
          booking_date: format_datetime(json['Booking Date'], json['Booking Time']),
          release_date: format_datetime(json['Release Date'], json['Release Time']),
          last_scraped_at: DateTime.now
        )
        arrest
      end

      def upsert_arrest_detail_html(arrest, json)
        arrest_details_html = ::TulsaBlotter::ArrestDetailsHtml.find_or_initialize_by(arrest: arrest)
        arrest_details_html.assign_attributes(
          html: json['html']['Details Html'],
          scraped_at: Time.current
        )
        arrest_details_html.save!
      end

      def upsert_all_offenses(arrest, arrest_json)
        arrest_json['Offenses'].each do |offense_json|
          upsert_offenses(arrest, offense_json)
        end
      end

      def upsert_offenses(arrest, json)
        if arrest.id
          offense = ::TulsaBlotter::Offense.find_by(case_number: json['Case Number'], arrests_id: arrest.id)
          offense ||= ::TulsaBlotter::Offense.find_by(description: json['Description'], arrests_id: arrest.id)
        end
        offense ||= ::TulsaBlotter::Offense.new
        offense.assign_attributes(
          arrest: arrest,
          bond_amount: Monetize.parse(json['Bond Amt']).to_f.round(2),
          bond_type: json['Bond Type'],
          case_number: json['Case #'],
          court_date: format_date(json['Court Date']),
          description: json['Description'],
          disposition: json['Disposition']
        )
        offense.save!
        offense
      end

      def page_json(page_number)
        Lambda.new.call('TulsaJailScraper', { 'page number': page_number })
      rescue LambdaErrorResponse => _e
        false
      end

      def format_datetime(date, time)
        DateTime.strptime("#{date} #{time}", '%m/%d/%Y %H:%M %p') if date.present? && time.present?
      end

      def format_date(date)
        Date.strptime(date.to_s, '%m/%d/%Y') if date.present?
      end

      def arresting_agency(string)
        string.split('/')[0].present? ? string.split('/')[0].strip : nil
      end

      def arresting_officer(string)
        string.split('/')[1].present? ? string.split('/')[1].strip : nil
      end
    end
  end
end
