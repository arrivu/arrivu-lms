Canvas.reloadable_plugin(File.dirname(__FILE__))

Rails.configuration.to_prepare do
  Wistia.register_plugin()
end
