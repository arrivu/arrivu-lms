#
# Copyright (C) 2011 Instructure, Inc.
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
module CC
  module CourseDescription

    def add_course_description
      return nil unless @course.course_description
      course_description_file = File.new(File.join(@canvas_resource_dir, CCHelper::COURSE_DESCRIPTION), 'w')
      rel_path = File.join(CCHelper::COURSE_SETTINGS_DIR, CCHelper::COURSE_DESCRIPTION)
      document = Builder::XmlMarkup.new(:target=>course_description_file, :indent=>2)

      document.instruct!
      document.course_description("identifier" =>  CCHelper.create_key(@course.course_description),
                      "xmlns" => CCHelper::CANVAS_NAMESPACE,
                      "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
                      "xsi:schemaLocation"=> "#{CCHelper::CANVAS_NAMESPACE} #{CCHelper::XSD_URI}"
      ) do |c|
        c.course_id @course.id
        c.account_id @course.account_id
        c.short_description @course.course_description.try(:short_description)
        c.long_description @course.course_description.try(:long_description)
      end
      course_description_file.close if course_description_file
      rel_path
    end
  end
end
