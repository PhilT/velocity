$(function(){
  $(".group").draggable({revertDuration: 300, revert: 'invalid', helper: 'clone'
  });
  $(".task").droppable({
    drop: function(event, ui) {
      alert("wuhoo!");
    }
  });
})

