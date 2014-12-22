$(document).ready(function () {
  if ($('.mainthumblarge').length) {
    var height = getPageHeight();
    console.log(height + ' ayy')
    //$('.comments').height($('.list').height() + $('.header').height() + 16);
    $('#mainpage').height(height);
    $('.infosection').height(height);
    $('.mainpageright').height(height);
    $('.mainpageleft').height(height);
}
});

function getPageHeight() {
  var right_height = $('.mainscreen').height() + $('.screenshots').height() + $('.list').height() + $('.header').height();
  var left_height = $('.sidebar').height();
  return (right_height >= right_height ? left_height : videos_height);
}