nplugm
------

[![npm version](https://badge.fury.io/js/nplugm.svg)](http://badge.fury.io/js/nplugm)
[![dependencies](https://david-dm.org/resin-io/nplugm.png)](https://david-dm.org/resin-io/nplugm.png)
[![Build Status](https://travis-ci.org/resin-io/nplugm.svg?branch=master)](https://travis-ci.org/resin-io/nplugm)
[![Build status](https://ci.appveyor.com/api/projects/status/1wck263ph9j4rq4v?svg=true)](https://ci.appveyor.com/project/jviotti/nplugm)

Join our online chat at [![Gitter chat](https://badges.gitter.im/resin-io/chat.png)](https://gitter.im/resin-io/chat)

NPM based plugin framework for NodeJS.

Introduction
------------

The purpose of this module is to provide an easy way to scan the system for globally installed npm packages that match a certain regular expression, so the application can require them and register them as plugins.

Installation
------------

Install `nplugm` by running:

```sh
$ npm install --save nplugm
```

Documentation
-------------

<a name="module_nplugm.list"></a>
### nplugm.list([regex]) ⇒ <code>Promise.&lt;Array.&lt;String&gt;&gt;</code>
If `regex` is a `String`, it will match all the plugins that start with it.

**Kind**: static method of <code>[nplugm](#module_nplugm)</code>  
**Summary**: List matching installed plugins  
**Returns**: <code>Promise.&lt;Array.&lt;String&gt;&gt;</code> - plugins  
**Access:** public  

| Param | Type | Default | Description |
| --- | --- | --- | --- |
| [regex] | <code>RegExp</code> &#124; <code>String</code> | <code>\/.*\/</code> | plugin matcher |

**Example**  
```js
nplugm.list(/^my-plugin-(\w+)$/).map (plugin) ->
	import = require(plugin)
	console.log("Registering: #{plugin}")
```

Support
-------

If you're having any problem, please [raise an issue](https://github.com/resin-io/nplugm/issues/new) on GitHub and the Resin.io team will be happy to help.

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

License
-------

The project is licensed under the MIT license.
