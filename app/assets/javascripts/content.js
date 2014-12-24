$(document).ready(function () {
  if ($('.mainthumblarge').length) {
    var height = getPageHeight();
    $('#mainpage').height(height);
    $('.infosection').height(height);
    $('.mainpageright').height(height);
    $('.mainpageleft').height(height);
    $('.mainpageleft').height(height);
    $('#mainpagewrap').height(height + 85);
    //$('#centerpage').height(height + 85); 
  }
});

function getPageHeight() {
  $('.comments').height($('.list').height() + $('.header').height() + 16);
  var right_height = $('.mainscreen').outerHeight(true) + $('.screenshots').outerHeight(true) + $('.comments').outerHeight(true);
  var left_height = $('.sidebar').height();
  return (right_height >= left_height ? right_height : left_height);
}