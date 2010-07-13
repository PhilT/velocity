Function.prototype.method = function (name, func) {
  this.prototype[name] = func;
  return this;
};

Object.method('shouldEqual', function(expected) {
  equal(String(this), expected);
});

function load(jsFile) {
   document.write('<script src="', jsFile, '" type="text/JavaScript"><\/script>');
}


var Factory = function() {
  var div = $('#factories');
  return {
    input: function() {
      alert(div);
      div.append("<input id='input' title='something'>");
    },
    something: function() {

    }
  }
}();

