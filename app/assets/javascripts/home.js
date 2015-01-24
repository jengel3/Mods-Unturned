$(document).on('submit', 'form#log_in_user', function(e) {
}).on('ajax:success', 'form#log_in_user', function(e, data, status, xhr) {
	// reload the page now that the user is logged in
	location.reload(true);
}).on('ajax:error', 'form#log_in_user', function(e, data, status, xhr) {
	error = data.responseJSON.error;
	$('.signinwrap').find('.notificationtext').text(error);
	$('.signinwrap .errormessage').effect({effect: "shake", direction: "up", distance: 5, times: 2});
});

$(document).on('submit', 'form#register_user', function(e) {
}).on('ajax:success', 'form#register_user', function(e, data, status, xhr) {
	// reload the page now that the user is registered
	location.reload(true);
}).on('ajax:error', 'form#register_user', function(e, data, status, xhr) {
	errorResponse = data.responseText;
	formattedErrors = renderErrors(errorResponse);
	$('.registerwrap').find('.notificationtext').html(formattedErrors);
	if (formattedErrors.length > 1) {
		$('.registercircleinfo').css('visibility', 'hidden');
	} else {
		$('.registercircleinfo').css('visibility', 'visible');
	}
	$('.registerwrap .errormessage').effect({effect: "shake", direction: "up", distance: 5, times: 2});
});

function renderErrors(text) {
	var parsed = JSON.parse(text);
	var formattedErrors = [];
	$.each(parsed['errors'], function( index, value ) {
		var field_name = index;
		var errors = value;
		var uniqueErrors = [];
		$.each(errors, function(i, el){
			if($.inArray(el, uniqueErrors) === -1) { 
				uniqueErrors.push(el);
				var formatted = capitaliseFirstLetter(field_name.replace('_', ' ')) + " " + el;
				formattedErrors.push(formatted + "<br/>");
			}
		});        
	});
	return formattedErrors;

	function capitaliseFirstLetter(str) {
		return str.charAt(0).toUpperCase() + str.slice(1);
	}
}