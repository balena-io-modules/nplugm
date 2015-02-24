var _;

_ = require('lodash-contrib');

exports.prepareNpm = function(config, callback) {
  return npm.load(config, _.unary(callback));
};
