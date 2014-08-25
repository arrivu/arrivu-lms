class CourseDescription < ActiveRecord::Base
  attr_accessible :course_id,:account_id,:short_description,:long_description,:migration_id
  belongs_to :course
  belongs_to :account
  validates_presence_of :course_id,:presence =>true
  validates_presence_of :account_id,:presence =>true

  def self.process_migration(data, migration)
    course_description = data['course_description'] ? data['course_description']: []
     @course_desc = CourseDescription.find_or_create_by_course_id(migration.context.id,account_id: migration.context.account_id,
                                                                 short_description: course_description['short_description'],
                                                                 long_description: course_description['long_description'],
                                                                 migration_id: course_description['migration_id'])
     @course_desc.save!
  end

end
