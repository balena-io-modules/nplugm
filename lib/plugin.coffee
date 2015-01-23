path = require('path')
fs = require('fs')
fsPlus = require('fs-plus')
_ = require('lodash')
utils = require('./utils')

module.exports = class Plugin

	constructor: (@path) ->

		if not @path?
			throw new Error('Missing plugin path')

		if not _.isString(@path) or _.isEmpty(@path)
			throw new Error("Invalid plugin path: #{@path}")

		if not fs.existsSync(@path)
			throw new Error("Plugin does not exist: #{@path}")

		if not fsPlus.isDirectorySync(@path)
			throw new Error("Invalid plugin path: #{@path}")

		@manifestPath = @_getAbsoluteFilePath('package.json')

		if not fs.existsSync(@manifestPath)
			throw new Error("Plugin missing package.json: #{@path}")

		@manifest = utils.readJSON(@manifestPath)

	require: ->
		pluginEntryPoint = @manifest.main

		if _.isEmpty(pluginEntryPoint)
			throw new Error("Missing main property: #{@manifestPath}")

		absolutePluginEntryPoint = @_getAbsoluteFilePath(pluginEntryPoint)

		# TODO: This piece of code is untested, as there doesn't seem
		# to be an easy way to mock NodeJS's require() built in function.
		try
			result = require(absolutePluginEntryPoint)
		catch
			throw new Error("Error loading plugin: #{@path}")

		return result

	_getAbsoluteFilePath: (filePath) ->
		return @path if _.isEmpty(filePath)
		return path.join(@path, filePath)
