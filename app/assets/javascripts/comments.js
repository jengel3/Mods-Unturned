$(document).ready(function () {
  if ($('.mainthumblarge').length) {
    var height = getPageHeight();
    console.log(height)
    $('.comments').height($('.list').height() + $('.header').height() + 16);
    $('#mainpage').height(height);
    $('.infosection').height(height);
    $('.mainpageright').height(height);
    $('.mainpageleft').height(height);
  }
});

function getPageHeight() {
	var comments_height = $('.list').height() + $('.header').height() + 16;
	var videos_height = $('.videos').height();
	console.log(videos_height)
	console.log(comments_height)
	return (comments_height >= videos_height ? comments_height : videos_height) + 580;
}