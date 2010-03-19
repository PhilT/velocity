$(function(){

  setHintsOnTextfields();
  submitAssignedSelectOnChange();
  setupDraggableLists();
  showTaskInfo();
  toggleStoryTasks();
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

  function toggleStoryTasks() {
    $('.toggle').live('click', function() {
      if($(this).hasClass('open')) {
        $(this).closest('.title').siblings('.tasks').hide();
        $(this).removeClass('open');
        $(this).html('+');
      }
      else {
        $(this).closest('.title').siblings('.tasks').show();
        $(this).addClass('open');
        $(this).html('&ndash;');
      }
    });
  }

  function liveUpdates(){
    setInterval('$.get("/tasks/poll");', 30000);
  }
})

function updateReleaseBorder(velocity) {
  var count = 0;
  var length = 0;
  $('#stories .story').each(function(story) {
    length = $(this).find('.feature').length;
    count += length;
    if(count > velocity)  {
      drawReleaseBorder(this);
      return false;
    }
  });
}

function drawReleaseBorder(story) {
  $(story).before('<li class="release_border">(End of next release)</li>');
}
