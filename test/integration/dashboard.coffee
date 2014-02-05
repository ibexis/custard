should = require 'should'
{wd40, browser, base_url, login_url, home_url, prepIntegration} = require './helper'

describe 'Dashboard', ->
  prepIntegration()

  before (done) ->
    wd40.fill '#username', 'ehg', ->
      wd40.fill '#password', 'testing', ->
        wd40.click '#login', done

  context 'when I visit the dashboard page', ->
    before (done) ->
      browser.get "#{base_url}/dashboard", =>
        browser.waitForElementByCss '.dashboard > h1', 4000, =>
          wd40.getText 'body', (err, text) =>
            @bodyText = text
            done()

    it 'I see datasets from all the accounts I can switch into', (done) ->
      @bodyText.should.include 'Chris Blower'
      @bodyText.should.include 'Prune'
      @bodyText.should.include 'Apricot'
      @bodyText.should.include 'Ickle Test'
      @bodyText.should.include 'Cheese'
      browser.elementsByCss 'tr.dataset', (err, elements) ->
        elements.length.should.equal 3
        done()

    it 'there are links to switch into each of those data hubs', (done) ->
      wd40.elementByCss 'a[href="/switch/ehg"]', (err, a) ->
        should.exist a
        wd40.elementByCss 'a[href="/switch/ickletest"]', (err, a) ->
          should.exist a
          done()

    it 'the datasets are shown in two separate lists', (done) ->
      browser.elementsByCss '.dashboard > table', (err, elements) ->
        elements.length.should.equal 2
        done()

    it 'each dataset has an icon, name, owner, date created and status', (done) ->
      browser.elementsByCss 'tr.dataset td.icon', (err, elements) ->
        elements.length.should.equal 3
        browser.elementsByCss 'tr.dataset td.name', (err, elements) ->
          elements.length.should.equal 3
          browser.elementsByCss 'tr.dataset td.creator', (err, elements) ->
            elements.length.should.equal 3
            browser.elementsByCss 'tr.dataset td.created', (err, elements) ->
              elements.length.should.equal 3
              browser.elementsByCss 'tr.dataset td.status', (err, elements) ->
                elements.length.should.equal 3
                done()

    it 'clicking the datasets does nothing', (done) ->
      wd40.elementByCss 'tr[data-box="3006375815"] td.name', (err, td) ->
        td.click ->
          setTimeout ->
            browser.url (err, url) ->
              url.should.match /[/]dashboard[/]?$/
            done()
          , 500
