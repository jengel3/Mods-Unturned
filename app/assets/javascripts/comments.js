$(document).ready(function () {
	console.log()
	$('.comments').height($('.list').height() + $('.header').height() + 16)
	$('#mainpage').height($('.comments').height() + 550)
	$('.infosection').height($('#mainpage').height())
});
