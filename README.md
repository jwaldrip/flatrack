![Flatrack](https://raw.github.com/jwaldrip/flatrack/master/lib/flatrack/cli/templates/logo.png)
--

[![Version](http://allthebadges.io/jwaldrip/flatrack/badge_fury.png)](http://allthebadges.io/jwaldrip/flatrack/badge_fury)
[![Build Status](http://allthebadges.io/jwaldrip/flatrack/travis.png)](http://allthebadges.io/jwaldrip/flatrack/travis)
[![Coverage Status](https://coveralls.io/repos/jwaldrip/flatrack/badge.png?branch=master)](https://coveralls.io/r/jwaldrip/flatrack?branch=master)
[![Code Climate](http://allthebadges.io/jwaldrip/flatrack/code_climate.png)](http://allthebadges.io/jwaldrip/flatrack/code_climate)
[![Inline docs](http://inch-pages.github.io/github/jwaldrip/flatrack.png)](http://inch-pages.github.io/github/jwaldrip/flatrack)
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/jwaldrip/flatrack/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

## About
A simple rack web layer for delivering rendered static files.

## Installation

    $ gem install flatrack

## Creating your Flatrack site

    $ flatrack new my-website
    
### Structure

You should have 4 directories:

    - assets
    - layouts
    - pages
    - partials
    
#### Assets
Location of sprockets assets, flatrack comes with Sass and Coffeescript out of the box.

    - images
    - javascripts
    - stylesheets
    
#### Pages
Pages are the guts of your site, this is what your users will ultimately see. Basically put your content here.

#### Layouts
Layouts are the skin of your site, it's what takes all those guts that your users need and crave and puts them in a nice pretty layout for them to enjoy.

You can also define a custom layout using the following syntax:

```html+erb
<!-- /pages/my-view.html.erb -->
<%- use_layout :custom_layout %>
<p>Hello World</p>
```
    
## Running your site

    $ flatrack start
    
## How it works

Anything in `/pages` maps to a URL at `/`, root of a directory will always map to the `index.html.*` file in it.

**for example**

`GET /foo.html` would map to `/pages/foo.html.erb`, the erb (or any other format) is optional if you wish to render your pages dynamically.

## Templating Support

### Built in

* HTML
* ERB
* Ruby Evaluated Output

### Extensions

* HAML ([haml-flatrack](https://github.com/jwaldrip/haml-flatrack))
* Markdown ([redcarpet](https://github.com/vmg/redcarpet), [bluecloth](https://github.com/mislav/bluecloth/))
* Textile (Redcloth)
* _and more!_ (see [Tilt](https://github.com/rtomayko/tilt) for more details.)

### Sites using flatrack
___Pull Request to add yours!___

* [jasonwaldrip.com](http://jasonwaldrip.com)
* [carlypaige.com](http://carlypaige.com)

## Contributing

1. Fork it ( http://github.com/jwaldrip/flat-rack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
