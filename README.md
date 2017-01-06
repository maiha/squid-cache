# squid-cache [![Build Status](https://travis-ci.org/maiha/squid-cache.svg?branch=master)](https://travis-ci.org/maiha/squid-cache)

squid-cache utility

- powered by [crystal](http://crystal-lang.org/)-0.20.4
- squid-3.5.12

## Usage

```shell
% squid-cache check
/var/spool/squid/00/00/err:[meta(0).length](reading 4 bytes from 6) end of file reached

% squid-cache get http://...
HTTP/1.1 200 OK
...

% squid-cache keys
http://...
...

% squid-cache list
/var/spool/squid/00/00/0000000E: KEY_MD5(204)
...
```

## Contributing

1. Fork it ( https://github.com/maiha/squid-cache/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [maiha](https://github.com/maiha) maiha - creator, maintainer
