$(document).ready(function () {
  if ($('.unturnedupdates').length) {
    $.getJSON("/api/news",function(result){
      article = result['appnews']['newsitems'][0];
      title = article['title'];
      url = article['url'];
      content = article['contents'];
      $.post("/api/tohtml", JSON.stringify({ "bb_code": content}), contentType : 'application/json', function(result){
        $(".unturnednewsbubbletextarea").html(result);
      });
      $(".unturnednewsbubbleheading").text(title);
      $(".readmoretext").attr('href', url);
    });
  }
});
