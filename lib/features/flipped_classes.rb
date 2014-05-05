Feature.register('flipped_classes' => {
    display_name: lambda { I18n.t('features.flipped_classes', 'Flipped classes') },
    description: lambda { I18n.t('flipped_classes_description', <<END) },
This feature changes the modules listing in to Flipped Class design so that
we can add Pre-class materials,Videos etc.,
END
    applies_to: 'Course',
    state: 'allowed',
    root_opt_in: false,
    development: false
  }

)