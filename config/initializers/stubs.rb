# stubs go at the bottom of the autoload path so that a plugin's version will
# be found first
ActiveSupport::Dependencies.autoload_paths.unshift(Rails.root + 'lib/stubs')

# shard also makes modifications to AR, but those can't happen in our AR
# initializer, since it won't be able to find Shard until this initializer runs
Shard