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
    $('.comments').height($('.list').height() + $('.header').height() + 16);
    var right_height = $('.mainscreen').outerHeight(true) + $('.screenshots').outerHeight(true) + $('.comments').outerHeight(true);
    var left_height = $('.sidebar').height();
    console.log(right_height)
    console.log(left_height)
    return (right_height >= left_height ? right_height : left_height);
}