var Plugin, fs, fsPlus, path, utils, _;

path = require('path');

fs = require('fs');

fsPlus = require('fs-plus');

_ = require('lodash');

utils = require('./utils');

module.exports = Plugin = (function() {
  function Plugin(path) {
    this.path = path;
    if (this.path == null) {
      throw new Error('Missing plugin path');
    }
    if (!_.isString(this.path) || _.isEmpty(this.path)) {
      throw new Error("Invalid plugin path: " + this.path);
    }
    if (!fs.existsSync(this.path)) {
      throw new Error("Plugin does not exist: " + this.path);
    }
    if (!fsPlus.isDirectorySync(this.path)) {
      throw new Error("Invalid plugin path: " + this.path);
    }
    this.manifestPath = this._getAbsoluteFilePath('package.json');
    if (!fs.existsSync(this.manifestPath)) {
      throw new Error("Plugin missing package.json: " + this.path);
    }
    this.manifest = utils.readJSON(this.manifestPath);
  }

  Plugin.prototype.require = function() {
    var absolutePluginEntryPoint, pluginEntryPoint, result;
    pluginEntryPoint = this.manifest.main;
    if (_.isEmpty(pluginEntryPoint)) {
      throw new Error("Missing main property: " + this.manifestPath);
    }
    absolutePluginEntryPoint = this._getAbsoluteFilePath(pluginEntryPoint);
    try {
      result = require(absolutePluginEntryPoint);
    } catch (_error) {
      throw new Error("Error loading plugin: " + this.path);
    }
    return result;
  };

  Plugin.prototype._getAbsoluteFilePath = function(filePath) {
    if (_.isEmpty(filePath)) {
      return this.path;
    }
    return path.join(this.path, filePath);
  };

  return Plugin;

})();
