# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [3.0.3] - 2015-10-07

### Changed

- Scan `/usr/local/lib/node_modules` for plugins.

## [3.0.2] - 2015-10-06

### Changed

- Prevent duplicate plugins.

## [3.0.1] - 2015-10-06

### Changed

- Manually lookup `node_modules/` directories instead of relying on `npm`.

## [3.0.0] - 2015-08-19

### Added

- Write JSDoc documentation.
- Support for regular expressions.

### Removed

- Remove `nplugm#install()`.
- Remove `nplugm#update()`.
- Remove `nplugm#remove()`.
- Remove `nplugm#has()`.
- Remove `nplugm#require()`.

### Changed

- Expose a function interface instead of a class.
- Support promises instead of callbacks.

## [2.2.0] - 2015-04-17

### Added

- List globally installed modules.

## [2.1.0] - 2015-03-02

### Added

- Implement plugin update functionality.

## [2.0.1] - 2015-02-27
 
### Changed

- Silence npm list command to avoid annoying npm warnings in some cases.

## [2.0.0] - 2015-02-24

### Changed

- Major redesign. Delegate most logic to npm module and work with locally scoped plugins.

## [1.0.1] - 2015-01-23

### Changed

- Move `fs-plus` from dev depedencies to dependencies.

[3.0.3]: https://github.com/resin-io/nplugm/compare/v3.0.2...v3.0.3
[3.0.2]: https://github.com/resin-io/nplugm/compare/v3.0.1...v3.0.2
[3.0.1]: https://github.com/resin-io/nplugm/compare/v3.0.0...v3.0.1
[3.0.0]: https://github.com/resin-io/nplugm/compare/v2.2.0...v3.0.0
[2.2.0]: https://github.com/resin-io/nplugm/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/resin-io/nplugm/compare/v2.0.1...v2.1.0
[2.0.1]: https://github.com/resin-io/nplugm/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/resin-io/nplugm/compare/v1.0.1...v2.0.0
[1.0.1]: https://github.com/resin-io/nplugm/compare/v1.0.0...v1.0.1
