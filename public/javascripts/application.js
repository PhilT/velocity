$(function(){

  setHintsOnTextfields();
  submitAssignedSelectOnChange();
  setupDraggableLists();
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
    $('.stories').sortable({
      handle: '.story_handle',
      helper: 'clone',
      scrollSensivity: 40,
      update: function(event, ui){$.ajax({type: 'put', data: $(this).sortable('serialize'), url: '/stories/' + ui.item.attr('id').substr(6) + '/sort'})},
      axis: 'y'
    });

    $('.tasks').sortable({
      handle: '.handle',
      containment: 'parent',
      tolerance: 'pointer',
      update: function(event, ui){$.ajax({type: 'put', data: $(this).sortable('serialize'), url: '/tasks/' + ui.item.attr('id').substr(5) + '/sort'})},
      axis: 'y'
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

