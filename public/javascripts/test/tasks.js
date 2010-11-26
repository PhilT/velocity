$.fn.hint = function(blurClass) {
  $(this).addClass('hint');
}
load('/javascripts/application.js');


$(function(){
  module("application");

  test("hints load", 1, function() {
    $('#input').attr('class').shouldEqual('hint');
  });

});

