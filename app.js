// My SocketStream 0.3 app

var http = require('http'),
    ss = require('socketstream');

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
  code: ['libs/jquery.min.js', 'app'],
  tmpl: '*'
});

// Serve this client on the root URL

ss.http.route('/', function(req, res){
  ua = req.headers['user-agent']
  if ( /mobile/i.test(ua) )
    res.serveClient('remote')
  else
    res.serveClient('main');
});

ss.http.route('/login', function(req, res){
  res.serveClient('login');
});

ss.http.route('/remote', function(req, res){
  res.serveClient('remote');
});

ss.http.route('/mobile-login', function(req, res){
  res.serveClient('mobile_login');
});

// Code Formatters
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-stylus'));
ss.client.formatters.add(require('ss-jade'));

// Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use(require('ss-hogan'));

// Minimize and pack assets if you type: SS_ENV=production node app.js
if (ss.env === 'production') ss.client.packAssets();

// Start web server
var server = http.Server(ss.http.middleware);
server.listen(3000);

// Start ss-console
var ssconsole = require('ss-console')(ss);
ssconsole.listen(5000);

// Start SocketStream
ss.start(server);
