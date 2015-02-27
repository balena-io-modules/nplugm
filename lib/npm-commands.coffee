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
