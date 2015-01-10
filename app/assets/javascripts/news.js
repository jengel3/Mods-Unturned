$.extend({
  replaceTag: function (currentElem, newTagObj, keepProps) {
    var $currentElem = $(currentElem);
    var i, $newTag = $(newTagObj).clone();
        if (keepProps) {//{{{
          newTag = $newTag[0];
          newTag.className = currentElem.className;
          $.extend(newTag.classList, currentElem.classList);
          $.extend(newTag.attributes, currentElem.attributes);
        }//}}}
        $currentElem.wrapAll($newTag);
        $currentElem.contents().unwrap();
        // return node; (Error spotted by Frank van Luijn)
        return this; // Suggested by ColeLawrence
      }
    });

$.fn.extend({
  replaceTag: function (newTagObj, keepProps) {
        // "return" suggested by ColeLawrence
        return this.each(function() {
          jQuery.replaceTag(this, newTagObj, keepProps);
        });
      }
    });

$(document).ready(function () {
  if ($('.unturnedupdates').length) {
    $.getJSON("/api/news",function(result){
      article = result['appnews']['newsitems'][0];
      title = article['title'];
      url = article['url'];
      content = article['contents'];
      $.post("/api/tohtml", content, function(result) {
        result = result.replace("<img", "<a").replace("img>", "a>");
        $(".unturnednewsbubbletextarea").html(result);
        
        // $.each( $(".unturnednewsbubbletextarea a"), function( i, val ) {
        //   val.prop('href', $(this).prop('src'));
        // });
        
      });
      $(".unturnednewsbubbleheading").text(title);
      $(".readmoretext").attr('href', url);
    });
  }
});
