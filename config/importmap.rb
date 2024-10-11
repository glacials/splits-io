# Pin npm packages by running ./bin/importmap

pin_all_from "app/javascript"

pin "application", preload: true

pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "bootstrap" # @5.3.3
pin "chartkick" # @5.0.1
pin "jquery" # @3.7.1
pin "vue", preload: true # @3.5.10
pin "vue-turbolinks" # @2.2.2
pin "vue-tippy" # @6.4.4

pin_all_from "app/javascript/vue", to: "vue", under: "vue"
