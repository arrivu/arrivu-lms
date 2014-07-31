Canvas LMS
======

[![Build
Status](https://travis-ci.org/instructure/canvas-lms.png?branch=master)](https://travis-ci.org/instructure/canvas-lms)

Canvas is a new, open-source LMS by Instructure Inc. It is released under the
AGPLv3 license for use by anyone interested in learning more about or using
learning management systems.

[Please see our main wiki page for more information](http://github.com/instructure/canvas-lms/wiki)

Installation
=======

Detailed instructions for installation and configuration of Canvas are provided
on our wiki.

 * [Quick Start](http://github.com/instructure/canvas-lms/wiki/Quick-Start)
 * [Production Start](http://github.com/instructure/canvas-lms/wiki/Production-Start)
 * 

Tasks to populate 
=======

* Fix rename migration to migrate domain mapping get migrate first (bundle exec rake 'fix_domain_mapping')
* To populate subscription plans (bundle exec rake db:seed_subscription)
* Generate sample discussion topics (bundle exec rake db:populate)
* Fix module groups error (bundle exec rake db:fix_module_groups)
* Add another Root Account (bundle exec rake db:add_account)
