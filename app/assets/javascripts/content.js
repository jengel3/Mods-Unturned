$(document).ready(function () {
  if ($('.screenshots').length) {
    var height = Math.ceil(getPageHeight());
    $('#mainpage').height(height);
    $('.infosection').height(height);
    $('.mainpageright').height(height);
    $('.mainpageleft').height(height);
    $('#mainpagewrap').height(height + 85);

    $('.add-video-button').magnificPopup({
      type:'inline',
      midClick: true,
      mainClass: 'mfp-fade'
    });

    $('.popup-youtube').magnificPopup({
      disableOn: 700,
      type: 'iframe',
      mainClass: 'mfp-fade',
      removalDelay: 160,
      preloader: false,
    });

    $('.add-image-button').click(function() {
      if ($(this).parent().hasClass('edit-image-large')) {
        $('#image_location').val('Main');
        return;
      }
      var location = $(this).parent().parent().index() + 2;
      var selected = $('option[selected="selected"]').removeAttr('selected');
      var to_select = $('#image_location option:nth-child(' + location + ')');
      if (selected[0] == to_select[0]) {
        return;
      }
      to_select.parent().val(to_select.val());
    });

    $('.add-image-button').magnificPopup({
      type:'inline',
      midClick: true,
      mainClass: 'mfp-fade'
    });

    $('.screenshots').magnificPopup({
      delegate: '.valid-thumb',
      type: 'image',
      gallery: {
        enabled: true
      }
    });

    $('.report-comment-button').click(function() {
      var comment_id = $(this).closest('.comment').attr('id').replace('comment-', '');
      var form = $('#add-report-comment form');
      var old_action = form.attr('action');
      var action_split = old_action.split('/');
      var new_action = old_action.replace(action_split[action_split.length - 2], comment_id);
      form.attr('action', new_action);
    });
    
  }
});

function getPageHeight() {
  $('.comments').height($('.list').outerHeight(true) + $('.header').outerHeight(true));
  var right_height = $('.mainscreen').outerHeight(true) + $('.screenshots').outerHeight(true) + $('.comments').outerHeight(true) + 1;
  var left_height = $('.sidebar').height();
  return (right_height >= left_height ? right_height : left_height);
}