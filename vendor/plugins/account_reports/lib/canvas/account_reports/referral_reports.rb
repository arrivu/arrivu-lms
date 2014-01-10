#
# Copyright (C) 2012 - 2013 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

module Canvas::AccountReports

  class ReferralReports
    include Api
    include Canvas::AccountReports::ReportHelper
    include ReferralsHelper

    def initialize(account_report)
      @account_report = account_report
      extra_text_term(@account_report)
    end

    def referral_export()

      file = Canvas::AccountReports.generate_file(@account_report)
      CSV.open(file, "w") do |csv|

        list_rewards(account,for_report=true)

        csv << ['type','name','email','provider',
                'context_type','context_id', 'reward_name','reward_description',
                'expiry_date', 'coupon_code']
        Shackles.activate(:slave) do
          @referral_rewards.each do |u|
            row = []
            row << u[:type]
            row << u[:name]
            row << u[:email]
            row << u[:provider]
            row << u[:context_type]
            row << u[:context_id]
            row << u[:reward_name]
            row << u[:reward_description]
            row << u[:expiry_date]
            row << u[:coupon_code]
            csv << row
          end
        end
      end
      send_report(file)
    end

  end

end
