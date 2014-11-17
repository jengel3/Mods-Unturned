$(document).ready(function () {
	if ($('.mainthumblarge').length) {
		$('.comments').height($('.list').height() + $('.header').height() + 16);
		$('#mainpage').height($('.comments').height() + 550);
		$('.infosection').height($('#mainpage').height());
		$('.mainpageright').height($('#mainpage').height());
		$('.mainpageleft').height($('#mainpage').height());
	}
});
