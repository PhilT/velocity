$(function(){

  submitAssignedTo();
  setupDraggableLists();
  showTaskInfo();
  liveUpdates();
  updateReleaseBorder($('#velocity').attr('title'));
  allowRemoveGroup();
  setCategoryForNewTasks();

  function submitAssignedTo(){
    $('.ajaxSelect').live('change', function(){
      form = $(this).closest('form');
      $.put(form.attr('action'), form.serialize(), null, 'script');
      return false;
    });
  }

  function setupDraggableLists(){
    $('.tasks').sortable({
      handle: '.handle',
      containment: 'parent',
      tolerance: 'pointer',
      update: function(event, ui) {
        $.ajax({type: 'put', data: $(this).sortable('serialize'), url: '/tasks/' + ui.item.attr('id').substr(5) + '/sort'})
      },
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

  function allowRemoveGroup(){
    $('.task .group .delete_group').click(function(){
      $(this).closest('.group').effect('explode');
    });
  }

  function setCategoryForNewTasks(){
    $('.task_new .category a').click(function(){
      var li = $(this).closest('li');
      var categories = ['feature', 'bug', 'refactor'];
      var category = li.attr('class').replace('category ', '');
      var next = (categories.indexOf(category) + 1) % 3;
      li.addClass(categories[next]);
      li.removeClass(category);
      li.find('#task_category').attr('value', categories[next]);
      return false;
    });
  }
})

function scrollIntoView(task_id){
  var taskPosition = $(task_id).position().top;
  var viewHeight = $(window).height() - $('.new_task').height();
  var scrollPosition = $(document).scrollTop();

  var shouldScroll = (scrollPosition > taskPosition || scrollPosition + viewHeight < taskPosition);

  if(shouldScroll) {
    $(document).scrollTop(taskPosition);
  }
}

function updateReleaseBorder(velocity) {
  if(shouldUploadReleaseBorder()) {
    var tasks = $('.task').has('li.feature');
    if(tasks.length > velocity)  {
      tasks.eq(velocity).before('<li><h2 class="release_border"><span>End of Release</span></h2></li>');
      return false;
    }
  }
}

function shouldUploadReleaseBorder() {
  return window.location.pathname.match(/^\/(?:tasks)$/);
}
