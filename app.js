// My SocketStream 0.3 app

var http = require('http'),
    ss = require('socketstream'),
    char_set = 'abcdefghijklmnpqrstuvwxyz123456789';

var marlon_rando = function(len){
  var rando = '';
  var i = 0;
  len = len || 5;
  while( i < len ){
    random_pos = Math.floor(Math.random() * char_set.length);
    rando += char_set.substring(random_pos, random_pos + 1);
    i++;
  }
  return rando;
}

var setOrCreateUID = function(req, cb){
  if (req.session.userId) {
    cb();
  } else {
    req.session.userId = marlon_rando();
    req.session.save(cb);
  }
}


// Define a single-page client called 'main'
ss.client.define('main', {
  view: 'desktop_login.jade',
  css:  ['libs/reset.css', 'app.styl'],
  code: ['libs/jquery.min.js', 'app'],
  tmpl: '*'
});

// Define a single-page client called 'main'
ss.client.define('login', {
  view: 'desktop_login.jade',
  css:  ['libs/reset.css', 'app.styl'],
  code: ['libs/jquery.min.js', 'app'],
  tmpl: '*'
});

// Define a single-page client called 'remote'
ss.client.define('remote', {
  view: 'remote.jade',
  css:  ['libs/reset.css', 'app.styl'],
  code: ['libs/jquery.min.js', 'remote'],
  tmpl: '*'
});

// Serve this client on the root URL

ss.http.route('/', function(req, res){
  setOrCreateUID(req, function () { 
    ua = req.headers['user-agent']
    if ( /mobile/i.test(ua) )
      res.serveClient('remote')
    else
      res.serveClient('main')
  });
});

ss.http.route('/login', function(req, res){
  setOrCreateUID(req, function () { console.log(req); res.serveClient('login') });
});

ss.http.route('/remote', function(req, res){
  setOrCreateUID(req, function () { res.serveClient('remote') });
});

ss.http.route('/mobile-login', function(req, res){
  setOrCreateUID(req, function () { res.serveClient('mobile_login') });
});

// Code Formatters
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-stylus'));
ss.client.formatters.add(require('ss-jade'));

// Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use(require('ss-hogan'));

// Minimize and pack assets if you type: SS_ENV=production node app.js
if (ss.env === 'production') ss.client.packAssets();

// we should have seen this coming...
process.on('uncaughtException', function(e){
  console.log('UNCAUGHT EXCEPTION!', e)
});

// Start web server
var server = http.Server(ss.http.middleware);
server.listen(3000);

// Start ss-console
var ssconsole = require('ss-console')(ss);
ssconsole.listen(5000);

// Start SocketStream
ss.start(server);
