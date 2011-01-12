$(function() {
  $.ajax({type: 'GET', url: '/stats/graph_data', dataType: 'script', success: function() {
    $.plot($('#velocity'), [velocity], {
      xaxis: {mode: 'time'}, 
      grid: {hoverable: true},
      series: {
        lines: {show: true},
        points: {show: true}
      }
    });
    $('#velocity').bind('plothover', function(event, pos, item) {
      if(item) {
        $('#tooltip').remove();
        showTooltip(item.pageX, item.pageY, 'Velocity: ' + item.datapoint[1]);
      } else {
        $('#tooltip').remove();
      }
    })
    
    $.plot($('#features_and_bugs'), [{label: 'Features', data: features}, {label: 'Bugs', data: bugs}], {
      series: {
        bars: {
          show: true, 
          align: 'right', 
          barWidth: 1,
        }
      }
    });
  }});

  function showTooltip(x, y, contents) {
    $('<div id="tooltip">' + contents + '</div>').css( {
      position: 'absolute',
      display: 'none',
      top: y + 5,
      left: x + 5,
      border: '1px solid #fdd',
      padding: '2px',
      'background-color': '#fee',
      opacity: 0.80
    }).appendTo("body").fadeIn(200);
  }
});
