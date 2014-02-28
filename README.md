![Flatrack](https://raw.github.com/jwaldrip/flatrack/master/logo.png)

## About
A simple rack web layer for delivering rendered static files.

## Installation

    $ gem install flatrack

## Creating your Flatrack site

    $ flatrack new my-website
    
### Structure

You should have 3 directories:

    - assets
    - layouts
    - pages
    
#### Assets
Location of sprockets assets, flatrack comes with Sass and Coffeescript out of the box.

    - images
    - javascripte
    - stylesheets
    
#### Pages
Pages are the guts of your site, this is what your users will ultimately see. Basically put your content here.

#### Layouts
Layouts are the skin of your site, its what take all those guts that your users need and crave and put them in a nice pretty layout for them to enjoy.
    
## Running your site

    $ flatrack start
    
## How it works

Anything in `/pages` maps to a URL at `/`, root of a directory will always map to the `index.html.*` file in it.

**for example**

`GET /foo.html` would map to `/pages/foo.html.erb`, the erb (or any other format) is optional if you wish to render your pages dynamically.

## Contributing

1. Fork it ( http://github.com/<my-github-username>/flat-rack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
