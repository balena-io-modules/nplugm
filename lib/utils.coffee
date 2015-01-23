fs = require('fs')
fsPlus = require('fs-plus')

exports.readFile = (filePath) ->
	if not fs.existsSync(filePath)
		throw new Error("File not found: #{filePath}")

	if not fsPlus.isFileSync(filePath)
		throw new Error("Not a file: #{filePath}")

	return fs.readFileSync filePath,
		encoding: 'utf8'

exports.readJSON = (filePath) ->
	fileContents = exports.readFile(filePath)

	try
		result = JSON.parse(fileContents)
	catch
		throw new Error("Invalid JSON file: #{filePath}")

	return result
