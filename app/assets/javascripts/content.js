$(document).ready(function () {
  var height = Math.ceil(getPageHeight());
  $('#mainpage').height(height);
  $('.infosection').height(height);
  $('.mainpageright').height(height);
  $('.mainpageleft').height(height);
  $('#mainpagewrap').height(height + 85);
});

function getPageHeight() {
  $('.comments').height($('.list').outerHeight(true) + $('.header').outerHeight(true));
  var right_height = $('.mainscreen').outerHeight(true) + $('.screenshots').outerHeight(true) + $('.comments').outerHeight(true) + 1;
  var left_height = $('.sidebar').height();
  return (right_height >= left_height ? right_height : left_height);
}