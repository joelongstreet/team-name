// Read more at https://github.com/socketstream/socketstream/blob/master/doc/guide/en/web_workers.md
// in /client/workers/pi.js

self.addEventListener('message', function(e) {
  var cycles = e.data;
  postMessage("Calculating Pi using " + cycles + " cycles");
  var numbers = calculatePi(cycles);
  postMessage("Result: " + numbers);
}, false);

function calculatePi(cycles) {
  var pi = 0;
  var n  = 1;
  for (var i=0; i <= cycles; i++) {
    pi = pi + (4/n) - (4 / (n+2));
    n  = n  + 4;
  }
  return pi;
}


/**

// in any /client/code file
var worker = ss.load.worker('/pi.js');

// print output to console
worker.addEventListener('message', function(e) {
  console.log(e.data);
});

// start worker with 10000000 cycles
worker.postMessage(10000000);

**/