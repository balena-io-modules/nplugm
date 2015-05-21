nplugm
---------

[![npm version](https://badge.fury.io/js/nplugm.svg)](http://badge.fury.io/js/nplugm)
[![dependencies](https://david-dm.org/resin-io/nplugm.png)](https://david-dm.org/resin-io/nplugm.png)
[![Build Status](https://travis-ci.org/resin-io/nplugm.svg?branch=master)](https://travis-ci.org/resin-io/nplugm)
[![Build status](https://ci.appveyor.com/api/projects/status/1wck263ph9j4rq4v?svg=true)](https://ci.appveyor.com/project/jviotti/nplugm)

NPM based plugin framework for NodeJS.

**Nplugm went trough a major redesign to improve the reliability of the framework.**

[Checkout v1.0's README if you're still using that version.](https://github.com/resin-io/nplugm/blob/v1.0.1/README.md)

How it works
------------

Nplugm provides a framework to manage application plugins that consist of separate npm packages, installed locally in the parent application's `node_modules/` directory.

Nplugm provides CRUD operations to easily allow the application to install, remove, list, etc plugins.

Nplugm detects plugins my prefixing them with a specific string, usually the application's name.

Installation
------------

Install `nplugm` by running:

```sh
$ npm install --save nplugm
```

Documentation
-------------

The module exports a class, called `Nplugm`, that you instantiate based on a prefix.

#### Nplugm#constructor(String prefix)

The constructor requires a string prefix, usually in the form of `myapp-`.

In this case, plugins will be of the form `myapp-foo`, `myapp-bar` and so on.

#### Nplugm#list(Function callback)

Lists the currently installed applications.

The callback gets passed two arguments: `(error, plugins)`.

#### Nplugm#install(String plugin, Function callback)

Installs a plugin.

Notice that the string argument consists of the plugin name without the prefix. So as the above example, passing `foo` will actually install `myapp-foo`.

The callback gets passed one argument: `(error)`.

#### Nplugm#update(String plugin, Function callback)

Updates a plugin.

Notice that the string argument consists of the plugin name without the prefix. So as the above example, passing `foo` will actually install `myapp-foo`.

The callback gets passed two arguments: `(error, version)`, where version is the version to which the plugin was updated.

#### Nplugm#remove(String plugin, Function callback)

Removes a plugin.

Notice that the string argument consists of the plugin name without the prefix. So as the above example, passing `foo` will actually uninstall `myapp-foo`.

The callback gets passed one argument: `(error)`.

#### Nplugm#has(String plugin, Function callback)

Check that a plugin is installed.

The callback gets passed two arguments: `(error, hasPlugin)`.

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

### v2.2.0

List globally installed plugins.

### v2.1.0

Implement plugin update functionality.

### v2.0.1

Silence npm list command to avoid annoying npm warnings in some cases.

### v2.0.0

Major redesign. Delegate most logic to npm module and work with locally scoped plugins.

### v1.0.1

Fix issue with `fs-plus` being declared as a dev dependency.

License
-------

The project is licensed under the MIT license.
