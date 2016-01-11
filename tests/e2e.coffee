m = require('mochainon')
Promise = require('bluebird')
shell = require('shelljs')
nplugm = require('../lib/nplugm')

tests = [

	->
		console.log('It should list globally installed modules')

		shell.exec('npm uninstall --global generator-angular', silent: true)
		shell.exec('npm uninstall --global generator-polymer', silent: true)

		# Install dependencies
		shell.exec('npm install --global generator-angular', silent: true)
		shell.exec('npm install --global generator-polymer', silent: true)

		nplugm.list(/^generator-(.+)$/).then (plugins) ->

			m.chai.expect(plugins).to.deep.equal [
				'generator-generator'
				'generator-polymer'
			]

]

Promise.reduce tests, (_, test) ->
	return test()
, null
