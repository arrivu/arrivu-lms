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
  },
    'e_learning' =>
     {
         display_name: -> { I18n.t('features.e_learning', 'E Learning') },
         description: -> { I18n.t('e_learning_description', <<END) },
Enabling E Learning Provides home pages for the domain instead of loading login page
on the start page. Organizations can show case there course and can sell the courses
using payment integration.
END
         applies_to: 'RootAccount',
         state: 'hidden',
         root_opt_in: true,
         locking_account_id: 1
     },
'private_e_learning' =>
    {
        display_name: -> { I18n.t('features.private_e_learning', 'Private E Learning') },
        description: -> { I18n.t('private_e_learning_description', <<END) },
Enabling Private E Learning Provides ,Autenticated users only can see the accounts
course content and E Learning home page and enrollment.
END
        applies_to: 'RootAccount',
        state: 'allowed',
        root_opt_in: false
    }

)