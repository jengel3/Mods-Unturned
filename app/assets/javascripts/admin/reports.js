if (typeof String.prototype.startsWith != 'function') {
  String.prototype.startsWith = function (str){
    return this.indexOf(str) == 0;
  };
}

$(document).ready(function () {
	$('.approve, .deny').click(function() {
		var element = $(this);
		var id = 0;
		var url = '';
		if ($(this).attr('id').startsWith('deny')) {
			id = $(this).attr('id').split('deny-')[1];
			url = "/uploads/" + id + '/deny';
		} else {
			id = $(this).attr('id').split('approve-')[1];
			url = "/uploads/" + id + '/approve';
		}
		url += '.json';
		var prompt = 'No reason provided.';
		if ($(this).hasClass('deny')) {
			prompt = window.prompt("Why is this file being denied?", "Content is not up to Mods-Unturned standards.");
		}
		$.ajax({
			url: url,
			type: "POST",
			data: JSON.stringify({"reason": prompt}),
			success: function(resp) {
				$(element).closest('tr').fadeOut( "slow", function() { 
					$(element).remove();
					recalcHeight();
				});
			}
		});
	});
});