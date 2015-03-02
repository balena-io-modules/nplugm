_ = require('lodash-contrib')
_.str = require('underscore.string')
npmCommands = require('./npm-commands')

# TODO: Implement a search function. Maybe use npmKeyword module?

module.exports = class Nplugm

	constructor: (@prefix) ->

		if not @prefix?
			throw new Error('Missing prefix argument')

		if not _.isString(@prefix)
			throw new Error("Invalid prefix argument: not a string: #{@prefix}")

	list: (callback) ->
		npmCommands.list (error, plugins) =>
			return callback?(error) if error?

			matchPlugins = _.filter plugins, (plugin) =>
				return _.str.startsWith(plugin.name, @prefix)

			matchPlugins = _.map matchPlugins, (plugin) =>
				plugin.name = plugin.name.replace(@prefix, '')
				return plugin

			return callback?(null, matchPlugins)

	install: (plugin, callback) ->

		if not plugin?
			throw new Error('Missing plugin argument')

		if not _.isString(plugin)
			throw new Error("Invalid plugin argument: not a string: #{plugin}")

		return npmCommands.install(@prefix + plugin, _.unary(callback))

	update: (plugin, callback) ->

		@has plugin, (error, hasPlugin) =>
			return callback(error) if error?

			if not hasPlugin
				return callback(new Error("Plugin not found: #{plugin}"))

			npmCommands.update @prefix + plugin, (error, version) ->
				return callback(error) if error?

				if not version?
					error = new Error("Plugin is already at latest version: #{plugin}")
					return callback(error)

				return callback(null, version)

	remove: (plugin, callback) ->

		if not plugin?
			throw new Error('Missing plugin argument')

		if not _.isString(plugin)
			throw new Error("Invalid plugin argument: not a string: #{plugin}")

		return npmCommands.remove(@prefix + plugin, _.unary(callback))

	has: (plugin, callback) ->

		if not plugin?
			throw new Error('Missing plugin argument')

		if not _.isString(plugin)
			throw new Error("Invalid plugin argument: not a string: #{plugin}")

		@list (error, plugins) ->
			return callback?(error) if error?
			return callback?(null, _.findWhere(plugins, name: plugin)?)

	require: (plugin) ->

		if not plugin?
			throw new Error('Missing plugin argument')

		if not _.isString(plugin.name)
			throw new Error("Invalid plugin argument: not a string: #{plugin.name}")

		try
			return require(@prefix + plugin.name)
		catch
			throw new Error("Plugin not found: #{plugin.name}")
