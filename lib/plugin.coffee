path = require('path')
fs = require('fs')
fsPlus = require('fs-plus')
_ = require('lodash')

module.exports = class Plugin

	constructor: (pluginPath) ->
		if not pluginPath?
			throw new Error('Missing plugin path')

		if not _.isString(pluginPath) or _.isEmpty(pluginPath)
			throw new Error("Invalid plugin path: #{pluginPath}")

		if not fs.existsSync(pluginPath)
			throw new Error("Plugin does not exist: #{pluginPath}")

		if not fsPlus.isDirectorySync(pluginPath)
			throw new Error("Invalid plugin path: #{pluginPath}")

		if not fs.existsSync(path.join(pluginPath, 'package.json'))
			throw new Error("Plugin missing package.json: #{pluginPath}")

		@path = pluginPath
		@manifest = @_readJSON('package.json')

	_readFile: (filePath) ->
		absoluteFilePath = path.join(@path, filePath)

		if not fs.existsSync(absoluteFilePath)
			throw new Error("File not found: #{absoluteFilePath}")

		if not fsPlus.isFileSync(absoluteFilePath)
			throw new Error("Not a file: #{absoluteFilePath}")

		return fs.readFileSync absoluteFilePath,
			encoding: 'utf8'

	_readJSON: (filePath) ->
		fileContents = @_readFile(filePath)

		try
			result = JSON.parse(fileContents)
		catch
			absoluteFilePath = path.join(@path, filePath)
			throw new Error("Invalid JSON file: #{absoluteFilePath}")

		return result
