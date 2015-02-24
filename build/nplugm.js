var Nplugm, npmCommands, _;

_ = require('lodash-contrib');

_.str = require('underscore.string');

npmCommands = require('./npm-commands');

module.exports = Nplugm = (function() {
  function Nplugm(prefix) {
    this.prefix = prefix;
    if (this.prefix == null) {
      throw new Error('Missing prefix argument');
    }
    if (!_.isString(this.prefix)) {
      throw new Error("Invalid prefix argument: not a string: " + this.prefix);
    }
  }

  Nplugm.prototype.list = function(callback) {
    return npmCommands.list((function(_this) {
      return function(error, plugins) {
        var matchPlugins;
        if (error != null) {
          return typeof callback === "function" ? callback(error) : void 0;
        }
        matchPlugins = _.filter(plugins, function(plugin) {
          return _.str.startsWith(plugin, _this.prefix);
        });
        return typeof callback === "function" ? callback(null, matchPlugins) : void 0;
      };
    })(this));
  };

  Nplugm.prototype.install = function(plugin, callback) {
    if (plugin == null) {
      throw new Error('Missing plugin argument');
    }
    if (!_.isString(plugin)) {
      throw new Error("Invalid plugin argument: not a string: " + plugin);
    }
    return npmCommands.install(this.prefix + plugin, _.unary(callback));
  };

  Nplugm.prototype.remove = function(plugin, callback) {
    if (plugin == null) {
      throw new Error('Missing plugin argument');
    }
    if (!_.isString(plugin)) {
      throw new Error("Invalid plugin argument: not a string: " + plugin);
    }
    return npmCommands.remove(this.prefix + plugin, _.unary(callback));
  };

  Nplugm.prototype.has = function(plugin, callback) {
    if (plugin == null) {
      throw new Error('Missing plugin argument');
    }
    if (!_.isString(plugin)) {
      throw new Error("Invalid plugin argument: not a string: " + plugin);
    }
    return this.list((function(_this) {
      return function(error, plugins) {
        if (error != null) {
          return typeof callback === "function" ? callback(error) : void 0;
        }
        return typeof callback === "function" ? callback(null, _.contains(plugins, _this.prefix + plugin)) : void 0;
      };
    })(this));
  };

  Nplugm.prototype.require = function(plugin) {
    if (plugin == null) {
      throw new Error('Missing plugin argument');
    }
    if (!_.isString(plugin)) {
      throw new Error("Invalid plugin argument: not a string: " + plugin);
    }
    try {
      return require(this.prefix + plugin);
    } catch (_error) {
      throw new Error("Plugin not found: " + plugin);
    }
  };

  return Nplugm;

})();
