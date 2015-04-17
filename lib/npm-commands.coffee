_ = require('lodash-contrib')
async = require('async')
npm = require('npm')

exports.list = (callback) ->
	async.waterfall([

		(callback) ->
			options =
				depth: 0
				parseable: true
				loglevel: 'silent'
				global: true

			npm.load(options, _.unary(callback))

		(callback) ->
			npm.commands.list([], true, callback)

		(data, lite, callback) ->
			return callback(null, _.values(data.dependencies))

	], callback)

exports.install = (name, callback) ->
	async.waterfall [

		(callback) ->
			npm.load(loglevel: 'silent', _.unary(callback))

		(callback) ->

			# TODO: This action outputs installation information that cannot
			# be quieted neither with --quiet nor --silent:
			# https://github.com/npm/npm/issues/2040
			npm.commands.install([ name ], callback)

		(installedModules, modules, lite, callback) ->
			installedModules = _.map(installedModules, _.first)
			return callback(null, installedModules)

	], (error, installedModules) ->
		return callback(null, installedModules) if not error?

		if error.code is 'E404'
			error.message = "Plugin not found: #{name}"

		return callback(error) if error?

exports.update = (name, callback) ->
	async.waterfall [

		(callback) ->
			npm.load(loglevel: 'silent', _.unary(callback))

		(callback) ->
			npm.commands.update([ name ], callback)

		(installedModules, callback) ->
			installedModules = _.map(installedModules, _.first)
			installedModule = _.first(installedModules)
			installedModuleVersion = _.last(installedModule.split('@'))
			return callback(null, installedModuleVersion)

	], (error, version) ->
		return callback(null, version) if not error?

		if error.code is 'E404'
			error.message = "Plugin not found: #{name}"

		return callback(error) if error?

exports.remove = (name, callback) ->
	async.waterfall([

		(callback) ->
			npm.load(loglevel: 'silent', _.unary(callback))

		(callback) ->
			npm.commands.uninstall([ name ], callback)

		(uninstalledPlugins, callback) ->
			if _.isEmpty(uninstalledPlugins)
				return callback(new Error("Plugin not found: #{name}"))
			return callback(null, _.first(uninstalledPlugins))

	], callback)
