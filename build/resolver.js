
/*
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
 */
var Promise, npm, _;

Promise = require('bluebird');

npm = Promise.promisifyAll(require('npm'));

_ = require('lodash');


/**
 * @summary Lookup globally installed npm modules
 * @function
 * @protected
 *
 * @returns {Promise<String[]>} installed plugins
 *
 * @example
 * resolver.lookup().then (plugins) ->
 * 	for plugin in plugins
 * 		console.log(plugin)
 */

exports.lookup = function() {
  return npm.loadAsync({
    depth: 0,
    parseable: true,
    loglevel: 'silent',
    global: true
  }).then(function(instance) {
    return Promise.fromNode(function(callback) {
      return instance.commands.list([], true, callback);
    });
  }).spread(function(data) {
    return _.compact(_.pluck(_.values(data.dependencies), 'name'));
  });
};
