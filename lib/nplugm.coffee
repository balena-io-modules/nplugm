_ = require('lodash')
async = require('async')
fs = require('fs')
path = require('path')
yeoman = require('yeoman-environment')
glob = require('glob')
Plugin = require('./plugin')

exports.getNpmPaths = ->
	return yeoman.createEnv().getNpmPaths()

exports.getPluginsPathsByGlob = (pluginGlob, callback) ->

	if not pluginGlob?
		return callback(new Error('Missing glob'))

	if not _.isString(pluginGlob)
		return callback(new Error('Invalid glob'))

	npmPaths = exports.getNpmPaths()
	result = []

	for npmPath in npmPaths
		foundModules = glob.sync(pluginGlob, cwd: npmPath)
		foundModules = _.map foundModules, (foundModule) ->
			return path.join(npmPath, foundModule)

		result = result.concat(foundModules)

	return callback(null, result)

exports.load = (pluginGlob, pluginCallback, callback) ->
	async.waterfall([

		(callback) ->
			exports.getPluginsPathsByGlob(pluginGlob, callback)

		(pluginsPaths, callback) ->
			loadedPlugins = []

			for pluginPath in pluginsPaths
				try
					plugin = new Plugin(pluginPath)
					loadedPlugins.push(plugin)
					pluginCallback?(null, plugin)
				catch error
					pluginCallback?(error)

			return callback(null, loadedPlugins)

	], callback)
