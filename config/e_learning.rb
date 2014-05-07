# You can enable e-learning support by either defining a
# ELEARNING env var, or create an empty ELearning file in the sublime RAILS_ROOT dir
#(you must have a e-learning plugin also)
ELEARNING = !!ENV['ELEARNING'] || File.exist?(File.expand_path("../../ELEARNING", __FILE__))
LMSENABLED = !ELEARNING
