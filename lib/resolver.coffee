###
The MIT License

Copyright (c) 2015 Resin.io, Inc. https://resin.io

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
###

Promise = require('bluebird')
fs = Promise.promisifyAll(require('fs'))
_ = require('lodash')
os = require('os')
path = require('path')
yeomanResolver = require('yeoman-environment/lib/resolver')

###*
# @summary Get node_modules paths
# @function
# @protected
#
# @returns {String[]} node_modules paths
#
# @example
# paths = resolver.getNodeModulesPaths()
###
exports.getNodeModulesPaths = ->
	paths = yeomanResolver.getNpmPaths()

	# Scan directory where nplugm come from
	paths.push(path.resolve(require.resolve('nplugm'), '..', '..', '..'))

	if os.platform() isnt 'win32'
		paths.unshift('/usr/local/lib/node_modules')

	# Handle NVM
	if process.env.NVM_BIN?
		paths.unshift(path.resolve(process.env.NVM_BIN, '..', 'lib', 'node_modules'))

	return paths

###*
# @summary Lookup installed npm modules
# @function
# @protected
#
# @returns {Promise<String[]>} installed plugins
#
# @example
# resolver.lookup().then (plugins) ->
# 	for plugin in plugins
# 		console.log(plugin)
###
exports.lookup = ->
	Promise.try(exports.getNodeModulesPaths)
		.filter (directory) ->
			return fs.existsSync(directory)
		.map (directory) ->
			return fs.readdirAsync(directory).filter (file) ->
				return fs.existsSync(path.join(directory, file, 'package.json'))
		.then(_.flatten)
		.then(_.uniq)
