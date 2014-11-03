$(document).ready(function () {
	$('.comments').height($('.list').height() + $('.header').height() + 16)
	$('#mainpage').height($('.comments').height() + 550)
	$('.infosection').height($('#mainpage').height() - 17)
	$('.mainpageright').height($('#mainpage').height())
	$('.mainpageleft').height($('#mainpage').height())
});
