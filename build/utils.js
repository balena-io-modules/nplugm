var fs, fsPlus;

fs = require('fs');

fsPlus = require('fs-plus');

exports.readFile = function(filePath) {
  if (!fs.existsSync(filePath)) {
    throw new Error("File not found: " + filePath);
  }
  if (!fsPlus.isFileSync(filePath)) {
    throw new Error("Not a file: " + filePath);
  }
  return fs.readFileSync(filePath, {
    encoding: 'utf8'
  });
};

exports.readJSON = function(filePath) {
  var fileContents, result;
  fileContents = exports.readFile(filePath);
  try {
    result = JSON.parse(fileContents);
  } catch (_error) {
    throw new Error("Invalid JSON file: " + filePath);
  }
  return result;
};
