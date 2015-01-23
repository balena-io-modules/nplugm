nplugm
---------

[![npm version](https://badge.fury.io/js/nplugm.svg)](http://badge.fury.io/js/nplugm)
[![dependencies](https://david-dm.org/resin-io/nplugm.png)](https://david-dm.org/resin-io/nplugm.png)

NPM based plugin framework for NodeJS, inspired by [Yeoman's](http://yeoman.io/) generators.

[Yeoman](http://yeoman.io/) provides an extremely easy way to install third party generators by relying on NPM. The main concept, is that if you globally install any module that starts with `generator-`, it will be loaded by their command line tool automatically.

With `nplugm`, you can integrate the same functionality to any NodeJS application, easily.

```coffee
nplugm.load 'generator-*', (error, plugin) ->
	return console.error(error.message) if error?
	registerPlugin(plugin.require())
, (error, loadedPlugins) ->
	errors.handle(error) if error?
	console.log("Loaded #{loadedPlugins.length} plugins")
```

Installation
------------

Install `nplugm` by running:

```sh
$ npm install --save nplugm
```

Documentation
-------------

### nplugm.load(glob, pluginCallback, callback)

Search the system for plugins that match `glob`, and attempt to load each of them. This is probably the only `nplugm` function that you'll use most of the time.

#### glob

A [glob pattern](https://www.npmjs.com/package/glob) used to search for plugins in the system.

#### pluginCallback(error, plugin)

A function that gets called **for every plugin** that the framework attempts to load. It gets called with the following arguments:

- `error` a possible error when loading the plugin.
- `plugin` an instance of the `Plugin` class.

#### callback(error, loadedPlugins)

A function that gets called after all plugins were processed. It contains a possible error and the array of `Plugin` objects that got loaded successfully.

If no plugins were loaded, `loadedPlugins` will be an empty array.

Examples:

```coffee
nplugm.load 'x-plugin-*', (error, plugin) ->
	
	# Notice you can decide whether a plugin loading error
	# can crash or not your main application.
	if error?
		return console.error(error)
		
	# The way that the actual loaded plugin is used
	# is specific to your application.
	myApplicationPlugins.push(plugin.require())
	
, (error, loadedPlugins) ->
	throw error if error?
	
	console.log("The application loaded #{loadedPlugins.length} plugins")
```

### nplugm.getPluginsPathsByGlob(glob, callback)

It searches the system for plugins that match `glob`, and return an array of absolute paths to the search results.

If no plugin was found, an empty array is returned.

#### glob

A [glob pattern](https://www.npmjs.com/package/glob) used to search for plugins in the system.

#### callback(error, pluginPaths)

A function containing a possible error, and the array of paths.

Examples:

```coffee
nplugm.getPluginsPathsByGlob 'x-plugin-*', (error, pluginPaths) ->
	throw error if error?
	
	console.log('nplugm found the following plugins that match your criteria:')

	for pluginPath in pluginPaths
		console.log(pluginPath)
```

### nplugm.getNpmPaths()

Returns an array of strings containing all `node_modules/` locations that are searched by the framework.

It reuses [Yeoman's internal getNpmPaths() function](https://github.com/yeoman/environment/blob/master/lib/resolver.js#L109) to provide good cross operating system support.

Examples:

```coffee
console.log('nplugm searches for plugins in the following directories:')

for npmPath in nplugm.getNpmPaths()
	console.log(npmPath)
```

***

As mentioned before, `nplugm` returns instances of a `Plugin` class, which is a *private* class used by `nplugm` to abstract the concept of a plugin. 

You can't instantiate a `Plugin` class directly, but you can use the simple yet handy interface it expose to integrate the plugins to your application.

### Plugin#require()

A function that requires the entry point of the module (defined by `package.json` as the `main` property) and return it.

Notice this function may throw an error, that you can catch by using a `try/catch` construct.

Examples:

```coffee
myPlugin = plugin.require()
```

### Plugin#manifest

An object property that has the values from the plugin's `package.json`.

Examples:

	plugin.manifest.name
	plugin.manifest.dependencies[0]

Tests
-----

Run the test suite by doing:

```sh
$ gulp test
```

Contribute
----------

- Issue Tracker: [github.com/resin-io/nplugm/issues](https://github.com/resin-io/nplugm/issues)
- Source Code: [github.com/resin-io/nplugm](https://github.com/resin-io/nplugm)

Before submitting a PR, please make sure that you include tests, and that [coffeelint](http://www.coffeelint.org/) runs without any warning:

```sh
$ gulp lint
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/nplugm/issues/new) on GitHub.

ChangeLog
---------

### v1.0.1

Fix issue with `fs-plus` being declared as a dev dependency.

License
-------

The project is licensed under the MIT license.
