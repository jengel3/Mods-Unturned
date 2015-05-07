$(document).ready(function () {
  if ($('.screenshots').length) {
    $('.add-video-button').magnificPopup({
      type:'inline',
      midClick: true,
      mainClass: 'mfp-zoom-in',
      removalDelay: 500
    });

    $('.popup-youtube').magnificPopup({
      disableOn: 700,
      type: 'iframe',
      mainClass: 'mfp-zoom-in',
      removalDelay: 500,
      preloader: false,
    });

    $('.add-image-button').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-zoom-in',
      removalDelay: 500
    });

    $('.screenshots').magnificPopup({
      delegate: '.valid-thumb',
      type: 'image',
      gallery: {
        enabled: true
      }
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