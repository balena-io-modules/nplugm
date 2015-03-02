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
          return _.str.startsWith(plugin.name, _this.prefix);
        });
        matchPlugins = _.map(matchPlugins, function(plugin) {
          plugin.name = plugin.name.replace(_this.prefix, '');
          return plugin;
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

  Nplugm.prototype.update = function(plugin, callback) {
    return this.has(plugin, (function(_this) {
      return function(error, hasPlugin) {
        if (error != null) {
          return callback(error);
        }
        if (!hasPlugin) {
          return callback(new Error("Plugin not found: " + plugin));
        }
        return npmCommands.update(_this.prefix + plugin, function(error, version) {
          if (error != null) {
            return callback(error);
          }
          if (version == null) {
            error = new Error("Plugin is already at latest version: " + plugin);
            return callback(error);
          }
          return callback(null, version);
        });
      };
    })(this));
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
    return this.list(function(error, plugins) {
      if (error != null) {
        return typeof callback === "function" ? callback(error) : void 0;
      }
      return typeof callback === "function" ? callback(null, _.findWhere(plugins, {
        name: plugin
      }) != null) : void 0;
    });
  };

  Nplugm.prototype.require = function(plugin) {
    if (plugin == null) {
      throw new Error('Missing plugin argument');
    }
    if (!_.isString(plugin.name)) {
      throw new Error("Invalid plugin argument: not a string: " + plugin.name);
    }
    try {
      return require(this.prefix + plugin.name);
    } catch (_error) {
      throw new Error("Plugin not found: " + plugin.name);
    }
  };

  return Nplugm;

})();
