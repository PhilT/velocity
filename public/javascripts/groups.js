$(function(){
  $(".group").draggable({revertDuration: 300, revert: 'invalid', helper: 'clone'});
  $(".task").droppable({
    hoverClass: 'drop_here',
    drop: function(event, ui) {
      $.put('/tasks/' + $(this).attr('id').substr(5), {group_id: ui.draggable.attr('id').substr(6)});
    }
  });
})

