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

	describe '#_readFile()', ->

		describe 'given a file that exists', ->

			beforeEach ->
				mockFs
					'/plugin':
						'hello': 'world'
						'package.json': JSON.stringify({})

				@plugin = new Plugin(path.join('/', 'plugin'))
				@filePath = 'hello'

			afterEach ->
				mockFs.restore()

			it 'should read that file', ->
				result = @plugin._readFile(@filePath)
				expect(result).to.equal('world')

		describe 'given a file that does not exists', ->

			beforeEach ->
				mockFs
					'/plugin':
						'package.json': JSON.stringify({})

				@plugin = new Plugin(path.join('/', 'plugin'))
				@filePath = 'hello'

			afterEach ->
				mockFs.restore()

			it 'should read that file', ->
				expect =>
					@plugin._readFile(@filePath)
				.to.throw("File not found: #{path.join(@plugin.path, @filePath)}")

		describe 'given a directory', ->

			beforeEach ->
				mockFs
					'/plugin':
						'hello': {}
						'package.json': JSON.stringify({})

				@plugin = new Plugin(path.join('/', 'plugin'))
				@filePath = 'hello'

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				expect =>
					@plugin._readFile(@filePath)
				.to.throw("Not a file: #{path.join(@plugin.path, @filePath)}")

	describe '#_readJSON()', ->

		describe 'given a json file', ->

			beforeEach ->
				@packageJSON =
					name: 'myPlugin'
					description: 'My plugin'

				mockFs
					'/plugin':
						'package.json': JSON.stringify(@packageJSON)

				@plugin = new Plugin(path.join('/', 'plugin'))

			afterEach ->
				mockFs.restore()

			it 'should read and parse the file', ->
				result = @plugin._readJSON('package.json')
				expect(result).to.deep.equal(@packageJSON)

		describe 'given a non json file', ->

			beforeEach ->
				mockFs
					'/plugin':
						'package.json': JSON.stringify({})
						'hello': 'world'

				@plugin = new Plugin(path.join('/', 'plugin'))

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				expect =>
					@plugin._readJSON('hello')
				.to.throw("Invalid JSON file: #{path.join(@plugin.path, 'hello')}")
