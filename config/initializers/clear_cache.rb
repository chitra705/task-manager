Rails.application.config.after_initialize do
  Rails.cache.clear
  Rails.logger.info "Cache has been cleared"
end
