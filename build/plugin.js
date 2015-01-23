var Plugin, fs, fsPlus, path, _;

path = require('path');

fs = require('fs');

fsPlus = require('fs-plus');

_ = require('lodash');

module.exports = Plugin = (function() {
  function Plugin(pluginPath) {
    if (pluginPath == null) {
      throw new Error('Missing plugin path');
    }
    if (!_.isString(pluginPath) || _.isEmpty(pluginPath)) {
      throw new Error("Invalid plugin path: " + pluginPath);
    }
    if (!fs.existsSync(pluginPath)) {
      throw new Error("Plugin does not exist: " + pluginPath);
    }
    if (!fsPlus.isDirectorySync(pluginPath)) {
      throw new Error("Invalid plugin path: " + pluginPath);
    }
    if (!fs.existsSync(path.join(pluginPath, 'package.json'))) {
      throw new Error("Plugin missing package.json: " + pluginPath);
    }
    this.path = pluginPath;
    this.manifest = this._readJSON('package.json');
  }

  Plugin.prototype._readFile = function(filePath) {
    var absoluteFilePath;
    absoluteFilePath = path.join(this.path, filePath);
    if (!fs.existsSync(absoluteFilePath)) {
      throw new Error("File not found: " + absoluteFilePath);
    }
    if (!fsPlus.isFileSync(absoluteFilePath)) {
      throw new Error("Not a file: " + absoluteFilePath);
    }
    return fs.readFileSync(absoluteFilePath, {
      encoding: 'utf8'
    });
  };

  Plugin.prototype._readJSON = function(filePath) {
    var absoluteFilePath, fileContents, result;
    fileContents = this._readFile(filePath);
    try {
      result = JSON.parse(fileContents);
    } catch (_error) {
      absoluteFilePath = path.join(this.path, filePath);
      throw new Error("Invalid JSON file: " + absoluteFilePath);
    }
    return result;
  };

  return Plugin;

})();
