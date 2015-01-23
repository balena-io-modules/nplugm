path = require('path')
chai = require('chai')
expect = chai.expect
mockFs = require('mock-fs')
Plugin = require('../lib/plugin')

describe 'Plugin:', ->

	describe '#constructor()', ->

		it 'should throw if path is missing', ->
			expect ->
				new Plugin()
			.to.throw('Missing plugin path')

		it 'should throw if path is not a string', ->
			expect ->
				new Plugin([ '/my/plugin' ])
			.to.throw('Invalid plugin path: /my/plugin')

		it 'should throw if path is an empty string', ->
			expect ->
				new Plugin('')
			.to.throw('Invalid plugin path: ')

		describe 'given a path that does not exist', ->

			beforeEach ->
				mockFs()
				@pluginPath = path.join('/', 'not', 'exists')

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				expect =>
					new Plugin(@pluginPath)
				.to.throw("Plugin does not exist: #{@pluginPath}")

		describe 'given a path that is not a directory', ->

			beforeEach ->
				mockFs
					'/my/plugin': 'File contents'

				@pluginPath = path.join('/', 'my', 'plugin')

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				expect =>
					new Plugin(@pluginPath)
				.to.throw("Invalid plugin path: #{@pluginPath}")

		describe 'given a plugin without a package.json', ->

			beforeEach ->
				mockFs
					'/plugin': {}

				@pluginPath = path.join('/', 'plugin')

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				expect =>
					@plugin = new Plugin(@pluginPath)
				.to.throw("Plugin missing package.json: #{@pluginPath}")

		describe 'given a valid plugin', ->

			beforeEach ->
				@packageJSON =
					name: 'myPlugin'
					description: 'My Plugin'

				mockFs
					'/plugin':
						'package.json': JSON.stringify(@packageJSON)

				@pluginPath = path.join('/', 'plugin')
				@plugin = new Plugin(@pluginPath)

			afterEach ->
				mockFs.restore()

			it 'should append a path attribute', ->
				expect(@plugin.path).to.exist
				expect(@plugin.path).to.equal(@pluginPath)

			it 'should append the contents of package.json to manifest', ->
				expect(@plugin.manifest).to.deep.equal(@packageJSON)

	describe '#require()', ->

		describe 'given a manifest without main', ->

			beforeEach ->
				mockFs
					'/plugin/package.json': JSON.stringify
						name: 'myPlugin'
						description: 'My plugin'

				@plugin = new Plugin(path.join('/', 'plugin'))

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				packageJSONPath = path.join(@plugin.path, 'package.json')
				expect =>
					@plugin.require()
				.to.throw("Missing main property: #{packageJSONPath}")

	describe '#_getAbsoluteFilePath()', ->

		beforeEach ->
			mockFs
				'/plugin':
					'package.json': JSON.stringify({})

			@plugin = new Plugin(path.join('/', 'plugin'))

		afterEach ->
			mockFs.restore()

		describe 'given no path', ->

			it 'should return the plugin path', ->
				result = @plugin._getAbsoluteFilePath()
				expect(result).to.equal(@plugin.path)

		describe 'given a path', ->

			it 'should prepend the plugin path', ->
				result = @plugin._getAbsoluteFilePath('hello')
				expectedPath = path.join(@plugin.path, 'hello')
				expect(result).to.equal(expectedPath)
