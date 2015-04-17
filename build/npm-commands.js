var async, npm, _;

_ = require('lodash-contrib');

async = require('async');

npm = require('npm');

exports.list = function(callback) {
  return async.waterfall([
    function(callback) {
      var options;
      options = {
        depth: 0,
        parseable: true,
        loglevel: 'silent',
        global: true
      };
      return npm.load(options, _.unary(callback));
    }, function(callback) {
      return npm.commands.list([], true, callback);
    }, function(data, lite, callback) {
      return callback(null, _.values(data.dependencies));
    }
  ], callback);
};

exports.install = function(name, callback) {
  return async.waterfall([
    function(callback) {
      return npm.load({
        loglevel: 'silent'
      }, _.unary(callback));
    }, function(callback) {
      return npm.commands.install([name], callback);
    }, function(installedModules, modules, lite, callback) {
      installedModules = _.map(installedModules, _.first);
      return callback(null, installedModules);
    }
  ], function(error, installedModules) {
    if (error == null) {
      return callback(null, installedModules);
    }
    if (error.code === 'E404') {
      error.message = "Plugin not found: " + name;
    }
    if (error != null) {
      return callback(error);
    }
  });
};

exports.update = function(name, callback) {
  return async.waterfall([
    function(callback) {
      return npm.load({
        loglevel: 'silent'
      }, _.unary(callback));
    }, function(callback) {
      return npm.commands.update([name], callback);
    }, function(installedModules, callback) {
      var installedModule, installedModuleVersion;
      installedModules = _.map(installedModules, _.first);
      installedModule = _.first(installedModules);
      installedModuleVersion = _.last(installedModule.split('@'));
      return callback(null, installedModuleVersion);
    }
  ], function(error, version) {
    if (error == null) {
      return callback(null, version);
    }
    if (error.code === 'E404') {
      error.message = "Plugin not found: " + name;
    }
    if (error != null) {
      return callback(error);
    }
  });
};

exports.remove = function(name, callback) {
  return async.waterfall([
    function(callback) {
      return npm.load({
        loglevel: 'silent'
      }, _.unary(callback));
    }, function(callback) {
      return npm.commands.uninstall([name], callback);
    }, function(uninstalledPlugins, callback) {
      if (_.isEmpty(uninstalledPlugins)) {
        return callback(new Error("Plugin not found: " + name));
      }
      return callback(null, _.first(uninstalledPlugins));
    }
  ], callback);
};
