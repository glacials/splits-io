/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "jquery"
require("@rails/activestorage").start()
require("@rails/ujs").start()
require("turbolinks").start()
require("channels")
const moment = require('moment')
const momentDurationFormatSetup = require('moment-duration-format')

momentDurationFormatSetup(moment)

// Using Google charts for now (a script tag in app/views/layouts/admin/application.slim) because Chartkick + Highcharts
// doesn't seem to include axes, and tooltips don't include years (?) with no clear resolution
import Chartkick from "chartkick"
window.Chartkick = Chartkick

import "../ad_cleanup.js"
import "../analytics.js"
import "../convert.js"
import "../count.js"
import "../crisp.js"
import "../highchart_theme.js"
import "../chart_builder.js"
import "../landing.js"
import "../like.js"
import "../race_attach.js"
import "../run_claim.js"
import '../run_delete.js'
import '../run_disown.js'
import "../run_edit.js"
import "../run_export.js"
import "../search.js"
import "../settings.js"
import "../survey.js"
import "../timeline.js"
import "../token.js"
import "../tooltips.js"
import "../twitch.js"
import "../upload.js"
import "../vendor/toolkit.min.js"
