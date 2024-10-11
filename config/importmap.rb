# Pin npm packages by running ./bin/importmap

pin "application"
pin_all_from "app/javascript"
pin "vue" # @3.5.10
pin "jquery" # @3.7.1
pin "vue-turbolinks" # @2.2.2
pin "vue-tippy" # @6.4.4
pin "chartkick" # @5.0.1
pin "bootstrap" # @5.3.3
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8

# pin "race-disclaimer", to: "app/javascript/vue/race-disclaimer"
pin_all_from "app/javascript/vue", to: "vue", under: "vue"
