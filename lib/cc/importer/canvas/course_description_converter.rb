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
module CC::Importer::Canvas
  module CourseDescriptionConverter
    include CC::Importer

    def convert_course_description(doc)
      mod = {}
      return mod unless doc
      doc.css('course_description').each do |r_node|
        mod[:migration_id] = r_node['identifier']
        mod[:long_description] = get_node_val(r_node, 'long_description')
        mod[:short_description] = get_node_val(r_node, 'short_description')
        mod[:course_id] = get_int_val(r_node, 'course_id')
        mod[:account_id] = get_int_val(r_node, 'account_id')
        mod
      end
      mod
    end

  end
end
