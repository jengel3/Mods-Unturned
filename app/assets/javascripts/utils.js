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

function checkPasswordMatch() {
	var password = $(".registerwrap input[id='user_password']").val();
	var confirmPassword = $(".registerwrap input[id='user_password_confirmation']").val();

	if (confirmPassword === "" || password !== confirmPassword)
		$(".register-input[id='user_password_confirmation']").css("background-image", "url('<%= asset_path('password25.png') %>')");
	else
		$(".register-input[id='user_password_confirmation']").css("background-image", "url('<%= asset_path('lock26.png') %>')");
} 

function checkUserPasswordLength() {
	var userPassword = $(".signinwrap input[id='user_password']").val();

	if (userPassword.length >= 6 && userPassword.length <= 128) {
		$(".login-input[id='user_password']").css("background-image", "url('<%= asset_path('lock26.png') %>')")
	} else {
		$(".login-input[id='user_password']").css("background-image", "url('<%= asset_path('password25.png') %>')")
	}
}