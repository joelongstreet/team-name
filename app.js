// RowBro!

var http = require('http'),
    ss = require('socketstream');


//============================================================ Define SS clients

  // Define a single-page client called 'main'
  ss.client.define('main', {
    view: 'app.jade',
    css:  ['libs/reset.css', 'app.styl'],
    code: ['libs/jquery.min.js', 'common', 'app'],
    tmpl: '*'
  });

  // Define a single-page client called 'remote'
  ss.client.define('remote', {
    view: 'remote.jade',
    css:  ['libs/reset.css', 'app.styl'],
    code: ['libs/jquery.min.js', 'common', 'app'],
    tmpl: ['common', 'remote']
  });


//================================================================== HTTP Router

  // Serve this client on the root URL
  ss.http.route('/', function(req, res){
    ua = req.headers['user-agent']
    client = /mobile/i.test(ua) ? 'remote' : 'main'
    res.serveClient(client);
  });


//================================================================ Server Config
  
  // the in-built Redis transport
  // any config can be passed to the second argument
  ss.publish.transport.use('redis', {}); 

  // Code Formatters
  ss.client.formatters.add(require('ss-coffee'));
  ss.client.formatters.add(require('ss-stylus'));
  ss.client.formatters.add(require('ss-jade'));

  // Use server-side compiled Hogan (Mustache) templates.
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
