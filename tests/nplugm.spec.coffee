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

	describe '#getPluginMeta()', ->

		describe 'given an invalid plugin', ->

			beforeEach ->
				mockFs
					'/hello/world':
						'package.json': 'Invalid package.json'

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				pluginPath = path.join('/', 'hello', 'world')
				pluginPathPackageJSON = path.join(pluginPath, 'package.json')
				expect ->
					nplugm.getPluginMeta(pluginPath)
				.to.throw("Invalid JSON file: #{pluginPathPackageJSON}")

		describe 'given a plugin that exists', ->

			beforeEach ->
				mockFs
					'/hello/world':
						'package.json': JSON.stringify({ name: 'myPlugin' })

			afterEach ->
				mockFs.restore()

			it 'should return the parsed object', ->
				result = nplugm.getPluginMeta('/hello/world')
				expect(result).to.deep.equal
					name: 'myPlugin'

		describe 'given a plugin that does not exist', ->

			beforeEach ->
				@fsExistsSyncStub = sinon.stub(fs, 'existsSync')
				@fsExistsSyncStub.returns(false)

			afterEach ->
				@fsExistsSyncStub.restore()

			it 'should throw an error', ->
				expect ->
					nplugm.getPluginMeta('/hello/world')
				.to.throw('Plugin does not exist: /hello/world')
