$.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

$(function(){

  setHintsOnTextfields();
  setupNewTaskForm();

  function setupNewTaskForm(){
    $('.task_new').hide();
    $('#add_new_task span.message').hide();
    $('#add_new_task').click(function(){
      $('.task_new').slideToggle();
    });
    $('#new_task').submit(function(){
      $.post($(this).attr('action'), $(this).serialize(), null, "script");
      return false;
    });
  }

  function setHintsOnTextfields(){
    $('input[title!=""]').hint();
  }
})

