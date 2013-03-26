wd = require 'wd'

class wd40
  @init: (cb) ->
    browser.init
      browserName: process.env.BROWSER ? 'chrome'
      'chrome.switches': ['--disable-extensions']
    , (err) ->
      if err
        console.warn err
        console.warn "Is your Selenium server running? (see custard/README.md for instructions)"
      cb err

  @trueURL: (cb) ->
    browser.eval "window.location.href", cb

  @fill: (selector, text, cb) ->
    browser.waitForElementByCss selector, 4000, ->
      browser.elementByCss selector, (err, element) ->
        browser.type element, text, cb

  @clear: (selector, cb) ->
    browser.waitForElementByCss selector, 4000, ->
      browser.elementByCss selector, (err, element) ->
        browser.clear element, cb

  @click: (selector, cb) ->
    browser.waitForElementByCss selector, 4000, ->
      browser.elementByCss selector, (err, element) ->
        element.click cb

  @getText: (selector, cb) ->
    browser.waitForElementByCss selector, 4000, ->
      browser.elementByCss selector, (err, element) ->
        element.text cb

  # We always switch to the first frame here!
  @switchToFrame: (selector, cb) ->
    browser.waitForElementByCss selector, 4000, ->
      browser.frame 0, cb

  @switchToTopFrame: (cb) ->
    browser.windowHandle (err, handle) ->
      browser.window handle, cb

  @switchToBottomFrame: (cb) ->
    @switchToFrame 'iframe', =>
      @switchToFrame 'iframe', cb

  @waitForText: (text, cb) ->
    endTime = Date.now() + 4000
    poll = ->
      browser.text 'body', (err, result) ->
        if err
          return cb err
        if result.indexOf(text) > -1
          cb null
        else
          if Date.now() > endTime
            cb new Error("Element didn't appear")
          else
            setTimeout poll, 200
    poll()

exports.browser = browser = wd.remote()
exports.wd40 = wd40
