var Plugin, fs, glob, path, yeoman, _;

_ = require('lodash');

fs = require('fs');

path = require('path');

yeoman = require('yeoman-environment');

glob = require('glob');

Plugin = require('./plugin');

exports.getNpmPaths = function() {
  return yeoman.createEnv().getNpmPaths();
};

exports.getPluginsPathsByGlob = function(nameGlob) {
  var foundModules, npmPath, npmPaths, result, _i, _len;
  if (nameGlob == null) {
    throw new Error('Missing glob');
  }
  if (!_.isString(nameGlob)) {
    throw new Error('Invalid glob');
  }
  npmPaths = exports.getNpmPaths();
  result = [];
  for (_i = 0, _len = npmPaths.length; _i < _len; _i++) {
    npmPath = npmPaths[_i];
    foundModules = glob.sync(nameGlob, {
      cwd: npmPath
    });
    foundModules = _.map(foundModules, function(foundModule) {
      return path.join(npmPath, foundModule);
    });
    result = result.concat(foundModules);
  }
  return result;
};

exports.getPluginMeta = function(pluginPath) {
  var plugin;
  plugin = new Plugin(pluginPath);
  return plugin.manifest;
};
