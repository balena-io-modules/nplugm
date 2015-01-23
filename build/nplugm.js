var Plugin, async, fs, glob, path, yeoman, _;

_ = require('lodash');

async = require('async');

fs = require('fs');

path = require('path');

yeoman = require('yeoman-environment');

glob = require('glob');

Plugin = require('./plugin');

exports.getNpmPaths = function() {
  return yeoman.createEnv().getNpmPaths();
};

exports.getPluginsPathsByGlob = function(pluginGlob, callback) {
  var foundModules, npmPath, npmPaths, result, _i, _len;
  if (pluginGlob == null) {
    return callback(new Error('Missing glob'));
  }
  if (!_.isString(pluginGlob)) {
    return callback(new Error('Invalid glob'));
  }
  npmPaths = exports.getNpmPaths();
  result = [];
  for (_i = 0, _len = npmPaths.length; _i < _len; _i++) {
    npmPath = npmPaths[_i];
    foundModules = glob.sync(pluginGlob, {
      cwd: npmPath
    });
    foundModules = _.map(foundModules, function(foundModule) {
      return path.join(npmPath, foundModule);
    });
    result = result.concat(foundModules);
  }
  return callback(null, result);
};

exports.load = function(pluginGlob, pluginCallback, callback) {
  return async.waterfall([
    function(callback) {
      return exports.getPluginsPathsByGlob(pluginGlob, callback);
    }, function(pluginsPaths, callback) {
      var error, loadedPlugins, plugin, pluginPath, _i, _len;
      loadedPlugins = [];
      for (_i = 0, _len = pluginsPaths.length; _i < _len; _i++) {
        pluginPath = pluginsPaths[_i];
        try {
          plugin = new Plugin(pluginPath);
          loadedPlugins.push(plugin);
          if (typeof pluginCallback === "function") {
            pluginCallback(null, plugin);
          }
        } catch (_error) {
          error = _error;
          if (typeof pluginCallback === "function") {
            pluginCallback(error);
          }
        }
      }
      return callback(null, loadedPlugins);
    }
  ], callback);
};
