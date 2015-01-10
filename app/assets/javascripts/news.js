$(document).ready(function () {
  if ($('.unturnedupdates').length) {
    $.getJSON("/api/news", function(result){
      var title = result['title'];
      var url = result['url'];
      var content = result['content'];

      $(".unturnednewsbubbletextarea").html(content);

      $(".unturnednewsbubbletextarea img").each(function() {
        var href = $(this).attr('src');
        $(this).replaceWith("<strong><a href=" + href + " class=news-image>Click to open image. </a></strong>" );
        $(this).addClass('news-image');
      });

      $('.unturnednewsbubbletextarea').magnificPopup({
        delegate: '.news-image',
        type: 'image',
        gallery: {
          enabled: true
        }
      });

      $(".unturnednewsbubbleheading").text(title);
      $(".readmoretext").attr('href', url);
    });
  }
});
