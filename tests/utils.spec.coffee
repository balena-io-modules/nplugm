path = require('path')
chai = require('chai')
expect = chai.expect
mockFs = require('mock-fs')
utils = require('../lib/utils')

describe 'Utils:', ->

	describe '.readFile()', ->

		describe 'given a file that exists', ->

			beforeEach ->
				mockFs
					'/hello': 'world'

				@filePath = path.join('/', 'hello')

			afterEach ->
				mockFs.restore()

			it 'should read that file', ->
				result = utils.readFile(@filePath)
				expect(result).to.equal('world')

		describe 'given a file that does not exists', ->

			beforeEach ->
				mockFs()
				@filePath = path.join('/', 'hello')

			afterEach ->
				mockFs.restore()

			it 'should read that file', ->
				expect =>
					utils.readFile(@filePath)
				.to.throw("File not found: #{@filePath}")

		describe 'given a directory', ->

			beforeEach ->
				mockFs
					'/hello': {}

				@filePath = path.join('/', 'hello')

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				expect =>
					utils.readFile(@filePath)
				.to.throw("Not a file: #{@filePath}")

	describe '.readJSON()', ->

		describe 'given a json file', ->

			beforeEach ->
				@jsonContents =
					hello: 'world'

				mockFs
					'/hello.json': JSON.stringify(@jsonContents)

				@filePath = path.join('/', 'hello.json')

			afterEach ->
				mockFs.restore()

			it 'should read and parse the file', ->
				result = utils.readJSON(@filePath)
				expect(result).to.deep.equal(@jsonContents)

		describe 'given a non json file', ->

			beforeEach ->
				mockFs
					'/hello': 'world'

				@filePath = path.join('/', 'hello')

			afterEach ->
				mockFs.restore()

			it 'should throw an error', ->
				expect =>
					utils.readJSON(@filePath)
				.to.throw("Invalid JSON file: #{@filePath}")
