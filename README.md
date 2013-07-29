html2canvas_ruby_proxy
======================

Ruby (based on EventMachine) proxy for html2canvas

``` ruby
    
    ruby server.rb -sv
    # Listening to Listening on port 8082 ...

```
This proxy server is live at [heroku](http://html2canvas-ruby-proxy.herokuapp.com).

Try it:

``` javascript

    $.getJSON('http://html2canvas-ruby-proxy.herokuapp.com?url=http://inbound.anchorstl.com/wp-content/uploads/2013/01/rubyonrails.png&callback=?', function(data){ window.open(data,'_blank') })

```
