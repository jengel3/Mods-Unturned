// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).ready(function () {
	if ($('.moderation').length) {
		var height = $('.moderation').height();
		console.log(height)
		$('#mainpage').height(height);
		$('#mainpagewrap').height(height + 85);
		$('.mainpageleft').height(height);
	}
});