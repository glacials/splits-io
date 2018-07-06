/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import "jquery"
import "jquery-ujs"
import "moment"
import "underscore"
import {Spinner} from "spin.js"
import "clipboard"
import * as Cookies from "js-cookie"
import "jquery.turbolinks"

global.moment = moment
global._ = underscore
global.Spinner = Spinner
global.Clipboard = clipboard
global.Cookies = Cookies

import "../cable.js"
global.App = this.App
import "../cable/subscriptions/run.js"

import "../convert.js"
import "../highchart_theme.js"
import "../gon.js"
import "../graph_builder.js"
import "../search.js"
import "../segment_graph_builder.js"
import "../timeline.js"
import "../tooltips.js"
import "../vendor/toolkit.min.js"
