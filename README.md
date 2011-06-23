# Stopwatch

Show the time that was necessary to render your page and the amount of queries that were executed.

## Installation

Just add the following to your __development__ group and you are good to go:

``` ruby
gem 'stopwatch'
```

Every page will now display the duration in the upper right corner and the amount of queries. 

![Stopwatch in action](https://github.com/bittersweet/stopwatch/raw/master/stopwatch.png)

## Inspiration

I was inspired by an article on the [Coding Horror
blog](http://www.codinghorror.com/blog/2011/06/performance-is-a-feature.html)
where they talk about how adding a small box that displays page speed motivated
them to not forget about the performance of their pages.

Some excerpts:

> The simple act of putting a render time in the upper right hand corner of
> every page we serve forced us to fix all our performance regressions and
> omissions.

> In fact, with the render time appearing on every page for everyone on the dev
> team, performance became a point of pride. We had so many places where we had
> just gotten a little sloppy or missed some tiny thing that slowed a page down
> inordinately.

I could especially identify with the last one and I wanted to quickly get this
gem out there to see if I could recreate that same effect.

## Caveats

* It removes etags so we can display it fresh every page load, otherwise the
response would get cached by the browser because Rails would return a 304 Not
Modified and you wouldn't see any changes on page refresh.

## Todo

* Basic configuration
* Differentiate between cached and non-cached queries

## Thanks

[Paul Engel](https://github.com/archan937) For the name!

## License

Copyright (C) 2011 by Mark Mulder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
