/*
Jquery and Rails powered default application.js
Easy Ajax replacement for remote_functions and ajax_form based on class name
All actions will reply to the .js format
Unostrusive, will only works if Javascript enabled, if not, respond to an HTML as a normal link
respond_to do |format|
format.html
format.js {render :layout => false}
end
*/

/*
Augmented with live to handle DOM changes
*/

jQuery.ajaxSetup({
    beforeSend: function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")},
    dataType: 'script'
 })

function _ajax_request(url, data, callback, type, method) {
    if (jQuery.isFunction(data)) {
        callback = data;
        data = {};
    }
    return jQuery.ajax({
        type: method,
        url: url,
        data: data,
        success: callback,
        dataType: type
        });
}

jQuery.extend({
    put: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'PUT');
    },
    delete_: function(url, data, callback, type) {
        return _ajax_request(url, data, callback, type, 'DELETE');
    }
});

/*
Submit a form with Ajax
Use the class ajaxForm in your form declaration
<% form_for @comment,:html => {:class => "ajaxForm"} do |f| -%>
*/
jQuery.fn.submitWithAjax = function() {
  this.unbind('submit', false);
  this.live('submit', function() {
    $.post(this.action, $(this).serialize(), null, "script");
    return false;
  })

  return this;
};

/*
Retreive a page with get
Use the class get in your link declaration
<%= link_to 'My link', my_path(),:class => "get" %>
*/
jQuery.fn.getWithAjax = function() {
  this.unbind('click', false);
  this.live('click', function() {
    $.get($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

/*
Post data via html
Use the class post in your link declaration
<%= link_to 'My link', my_new_path(),:class => "post" %>
*/
jQuery.fn.postWithAjax = function() {
  this.unbind('click', false);
  this.live('click', function() {
    $.post($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

/*
Update/Put data via html
Use the class put in your link declaration
<%= link_to 'My link', my_update_path(data),:class => "put",:method => :put %>
*/
jQuery.fn.putWithAjax = function() {
  this.unbind('click', false);
  this.live('click', function() {
    $.put($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

/*
Delete data
Use the class delete in your link declaration
<%= link_to 'My link', my_destroy_path(data),:class => "delete",:method => :delete %>
*/
jQuery.fn.deleteWithAjax = function() {
  this.removeAttr('onclick');
  this.unbind('click', false);
  this.live('click', function() {
    $.delete_($(this).attr("href"), $(this).serialize(), null, "script");
    return false;
  })
  return this;
};

/*
Ajaxify all the links on the page.
This function is called when the page is loaded. You'll probaly need to call it again when you write render new datas that need to be ajaxyfied.'
*/
function ajaxLinks(){
    $('.ajaxForm').submitWithAjax();
    $('a.get').getWithAjax();
    $('a.post').postWithAjax();
    $('a.put').putWithAjax();
    $('a.delete').deleteWithAjax();
}

$(document).ready(function() {
// All non-GET requests will add the authenticity token
 $(document).ajaxSend(function(event, request, settings) {
       if (typeof(window.AUTH_TOKEN) == "undefined") return;
       // IE6 fix for http://dev.jquery.com/ticket/3155
       if (settings.type == 'GET' || settings.type == 'get') return;

       settings.data = settings.data || "";
       settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
     });

  ajaxLinks();
});



$(function(){

  setHintsOnTextfields();
  attachToStarted();
  setupDraggableLists();
  onlyShowUsersTasks();
  hideCompletedAndVerifiedTasks();
  showTaskInfo();

  function setHintsOnTextfields(){
    $('input[title!=""]').hint();
  }

  function attachToStarted(){
    $('input:checkbox, .ajaxSelect').live('change', function(){
      form = $(this).closest('form');
      $.put(form.attr('action'), form.serialize(), null, 'script');
      return false;
    });
  }

  function setupDraggableLists(){
    $('#now_tasks').sortable({
      handle: '.handle',
      connectWith: '#later_tasks',
      update: function(){$.ajax({type: 'put', data: $('#now_tasks').sortable('serialize'), url: '/tasks/sort?now=true'})}
    });

    $('#later_tasks').sortable({
      handle: '.handle',
      connectWith: '#now_tasks',
      update: function(){$.ajax({type: 'put', data: $('#later_tasks').sortable('serialize'), url: '/tasks/sort?now=false'})}
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
      $(this).closest('.task').find('.description').fadeIn('fast');
      $('.open').closest('.task').find('.description').fadeOut('fast');
      if($(this).hasClass('open')){
        $('.open').removeClass('open');
      }
      else{
        $('.open').removeClass('open');
        $(this).addClass('open');
      }
    });
  }
})

