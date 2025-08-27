# config/initializers/session_store.rb

Rails.application.config.session_store :cookie_store, key: '_task_session', expire_after: 12.hours
