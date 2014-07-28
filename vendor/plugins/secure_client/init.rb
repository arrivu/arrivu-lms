Rails.configuration.to_prepare do
  plugin = Canvas::Plugin.register :lockdown_browser, :lockdown_browser, {
      :name => lambda{ t :name, 'Secure Client' },
      :author => 'Arrivu Info Tech PVT.',
      :author_website => 'http://www.arrivusystems.com',
      :description => lambda{ t :description, 'Secure Client for quiz' },
      :version => '1.0.0',
      :settings_partial => 'plugins/secure_client_settings',
      :settings => {
          :enabled => true,
      },
      :base => SecureClient
  }

end

