// app/javascript/packs/application.js
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import { Turbo } from "@hotwired/turbo-rails"
import $ from 'jquery'

// Make jQuery available globally (if needed)
window.$ = $;
window.jQuery = $;

// Initialize Rails UJS, Turbolinks, ActiveStorage, and Turbo
Rails.start()
Turbolinks.start()
ActiveStorage.start()
Turbo.start()
