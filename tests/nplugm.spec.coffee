os = require('os')
_ = require('lodash')
path = require('path')
sinon = require('sinon')
chai = require('chai')
chai.use(require('sinon-chai'))
glob = require('glob')
fs = require('fs')
fsPlus = require('fs-plus')
mockFs = require('mock-fs')
expect = chai.expect
nplugm = require('../lib/nplugm')
Plugin = require('../lib/plugin')

describe 'nplugm:', ->

	describe '#getPluginsPathsByGlob()', ->

		describe 'given no glob', ->

			it 'should throw an error', ->
				expect ->
					nplugm.getPluginsPathsByGlob()
				.to.throw('Missing glob')

		describe 'given an invalid glob', ->

			it 'should throw an error', ->
				expect ->
					nplugm.getPluginsPathsByGlob([ 'glob' ])
				.to.throw('Invalid glob')

		describe 'given a glob that does not matches anything', ->

			beforeEach ->
				@globSyncStub = sinon.stub(glob, 'sync')
				@globSyncStub.returns []

				@nplugms = nplugm.getPluginsPathsByGlob('myGlob*')

			afterEach ->
				@globSyncStub.restore()

			it 'should return an empty array', ->
				expect(@nplugms).to.deep.equal([])

		describe 'given a glob that matches packages', ->

			beforeEach ->
				@getNpmPathsStub = sinon.stub(nplugm, 'getNpmPaths')

				if os.platform() is 'win32'
					@getNpmPathsStub.returns([ 'C:\\node_modules' ])
				else
					@getNpmPathsStub.returns([ '/usr/lib/node_modules' ])

				@globSyncStub = sinon.stub(glob, 'sync')
				@globSyncStub.returns [
					'one'
					'two'
					'three'
				]

				@plugins = nplugm.getPluginsPathsByGlob('myGlob*')

			afterEach ->
				@getNpmPathsStub.restore()
				@globSyncStub.restore()

			it 'should return an array', ->
				expect(@plugins).to.be.an.instanceof(Array)

			it 'should have the proper length', ->
				expect(@plugins).to.have.length(3)

			it 'should contain absolute paths', ->
				for pluginPath in @plugins
					expect(fsPlus.isAbsolute(pluginPath)).to.be.true

			it 'should return the appropriate paths', ->
				if os.platform() is 'win32'
					expect(@plugins[0]).to.equal('C:\\node_modules\\one')
					expect(@plugins[1]).to.equal('C:\\node_modules\\two')
					expect(@plugins[2]).to.equal('C:\\node_modules\\three')
				else
					expect(@plugins[0]).to.equal('/usr/lib/node_modules/one')
					expect(@plugins[1]).to.equal('/usr/lib/node_modules/two')
					expect(@plugins[2]).to.equal('/usr/lib/node_modules/three')

	describe '#getNpmPaths()', ->

		beforeEach ->
			@npmPaths = nplugm.getNpmPaths()

		it 'should return an array', ->
			expect(@npmPaths).to.be.an.instanceof(Array)

		it 'should return at least one path', ->
			expect(@npmPaths.length > 1).to.be.true

		it 'should contain absolute paths', ->
			for npmPath in @npmPaths
				expect(fsPlus.isAbsolute(npmPath)).to.be.true

	describe '#load()', ->

		describe 'given all valid plugins', ->

			beforeEach ->
				mockFs
					'/node_modules':
						'one':
							'package.json': JSON.stringify({})
						'two':
							'package.json': JSON.stringify({})

				@getPluginsPathsByGlobStub = sinon.stub(nplugm, 'getPluginsPathsByGlob')
				@getPluginsPathsByGlobStub.returns [
					path.join('/', 'node_modules', 'one')
					path.join('/', 'node_modules', 'two')
				]

			afterEach ->
				mockFs.restore()
				@getPluginsPathsByGlobStub.restore()

			it 'should load all the plugins', (done) ->
				spy = sinon.spy()

				nplugm.load 'my-plugin-*', spy, (error) ->
					expect(error).to.not.exist
					expect(spy).to.have.callCount(2)
					done()

			it 'should call the plugin callback with error and plugin args', (done) ->
				pluginCallbackSpy = sinon.spy (error, plugin) ->
					expect(error).to.not.exist
					expect(plugin).to.be.an.instanceof(Plugin)

				nplugm.load 'my-plugin-*', pluginCallbackSpy, (error) ->
					expect(error).to.not.exist
					done()

			it 'should provide a loadedPlugins array to the callback', (done) ->
				nplugm.load 'my-plugin-*', null, (error, loadedPlugins) ->
					expect(error).to.not.exist
					expect(loadedPlugins).to.have.length(2)

					for loadedPlugin in loadedPlugins
						expect(loadedPlugin).to.be.an.instanceof(Plugin)

					done()

		describe 'given one non valid plugin and one valid plugin', ->

			beforeEach ->
				mockFs
					'/node_modules':
						'one':
							'package.json': JSON.stringify({})
						'two': {}

				@getPluginsPathsByGlobStub = sinon.stub(nplugm, 'getPluginsPathsByGlob')
				@getPluginsPathsByGlobStub.returns [
					path.join('/', 'node_modules', 'one')
					path.join('/', 'node_modules', 'two')
				]

			afterEach ->
				mockFs.restore()
				@getPluginsPathsByGlobStub.restore()

			it 'should call plugin callback twice', (done) ->
				spy = sinon.spy()

				nplugm.load 'my-plugin-*', spy, (error) ->
					expect(error).to.not.exist
					expect(spy).to.have.callCount(2)
					done()

			it 'should only load one plugin', (done) ->
				nplugm.load 'my-plugin-*', null, (error, loadedPlugins) ->
					expect(error).to.not.exist
					expect(loadedPlugins).to.have.length(1)
					done()
