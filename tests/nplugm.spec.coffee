m = require('mochainon')
Promise = require('bluebird')
nplugm = require('../lib/nplugm')
resolver = require('../lib/resolver')

describe 'Nplugm:', ->

	describe '.list()', ->

		describe 'given no npm module was installed in the system', ->

			beforeEach ->
				@resolverListStub = m.sinon.stub(resolver, 'lookup')
				@resolverListStub.returns(Promise.resolve([]))

			afterEach ->
				@resolverListStub.restore()

			it 'should become an empty array no matter the regex', ->
				plugins = nplugm.list(/.*/)
				m.chai.expect(plugins).to.become([])

		describe 'given various installed npm modules', ->

			beforeEach ->
				@resolverListStub = m.sinon.stub(resolver, 'lookup')
				@resolverListStub.returns Promise.resolve [
					'myapp-plugin1'
					'myapp-plugin2'
					'myapp-plugin3'
					'myappplugin'
					'gulp'
					'grunt'
				]

			afterEach ->
				@resolverListStub.restore()

			it 'should become the plugins that match the regex', ->
				plugins = nplugm.list(/^myapp-(.+)$/)
				m.chai.expect(plugins).to.become [
					'myapp-plugin1'
					'myapp-plugin2'
					'myapp-plugin3'
				]

			it 'should become an empty array if no matches', ->
				plugins = nplugm.list(/^hello-(.+)$/)
				m.chai.expect(plugins).to.become([])

			it 'should become all plugins if no regex', ->
				plugins = nplugm.list()
				m.chai.expect(plugins).to.become [
					'myapp-plugin1'
					'myapp-plugin2'
					'myapp-plugin3'
					'myappplugin'
					'gulp'
					'grunt'
				]

			it 'should match with a string', ->
				plugins = nplugm.list('gulp')
				m.chai.expect(plugins).to.become([ 'gulp' ])

			it 'should match with a string as prefix', ->
				plugins = nplugm.list('myapp')
				m.chai.expect(plugins).to.become [
					'myapp-plugin1'
					'myapp-plugin2'
					'myapp-plugin3'
					'myappplugin'
				]
