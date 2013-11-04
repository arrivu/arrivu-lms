module SIS
  module CSV
    class UserAndEnrollmentImporter < CSVBaseImporter

      def self.is_user_and_enrollment_csv?(row)
        row.include?('user_id') && row.include?('provider')
      end

      # expected columns:
      # user_id,login_id,first_name,last_name,email,status
      def process(csv)
        messages = []
        @sis.counts[:users] += SIS::UserImporter.new(@root_account, importer_opts).process(@sis.updates_every, messages) do |importer|
          csv_rows(csv) do |row|
            update_progress

            begin
              importer.add_user(row['user_id'], row['provider'])

            rescue ImportError => e
              messages << "#{e}"
            end
          end
        end
        messages.each { |message| add_warning(csv, message) }
      end
    end
  end
end
