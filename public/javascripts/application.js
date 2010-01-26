$(function(){

  setHintsOnTextfields();
  submitAssignedSelectOnChange();
  setupDraggableLists();
  onlyShowUsersTasks();
  hideCompletedAndVerifiedTasks();
  showTaskInfo();
  liveUpdates();

  function setHintsOnTextfields(){
    $('input[title!=""]').hint();
  }

  function submitAssignedSelectOnChange(){
    $('.ajaxSelect').live('change', function(){
      form = $(this).closest('form');
      $.put(form.attr('action'), form.serialize(), null, 'script');
      return false;
    });
  }

  function setupDraggableLists(){
    $('#now_tasks').sortable({
      handle: '.handle',
      connectWith: '#later_tasks',
      update: function(event, ui){$.ajax({type: 'put', data: $('#now_tasks').sortable('serialize'), url: '/tasks/' + ui.item.attr('id') + '/sort?now=true'})},
      axis: 'y'
    });

    $('#later_tasks').sortable({
      handle: '.handle',
      connectWith: '#now_tasks',
      update: function(event, ui){$.ajax({type: 'put', data: $('#later_tasks').sortable('serialize'), url: '/tasks/' + ui.item.attr('id') + '/sort?now=false'})},
      axis: 'y'
    });
  }

  function onlyShowUsersTasks(){
    $('#filter_yours').live('change', function(){
      if($(this).attr('checked')){
        $('.other').hide();
      }
      else{
        if($('#filter_completed')){
          $('.pending.other, .started.other').show();
        }
        else{
          $('.other').show();
        }
      }
    });
  }

  function hideCompletedAndVerifiedTasks(){
    $('#filter_completed').live('change', function(){
      if($(this).attr('checked')){
        $('.completed, .verified').hide();
      }
      else{
        if($('#filter_yours').attr('checked')){
          $('.completed.assigned, .verified.assigned').show();
        }
        else{
          $('.completed,.verified').show();
        }
      }
    });
  }

  function showTaskInfo(){
    $('.info').live('click', function(){
      $(this).closest('.task').find('.description').slideDown('fast');
      $('.open').closest('.task').find('.description').slideUp('fast');
      if($(this).hasClass('open')){
        $('.open').removeClass('open');
      }
      else{
        $('.open').removeClass('open');
        $(this).addClass('open');
      }
    });
  }

  function liveUpdates(){
    setInterval('$.get("/tasks/poll");', 30000);
  }
})

