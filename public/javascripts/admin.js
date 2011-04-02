$(document).ready(function() {
	addListeners();
});

function addListeners(){
	$('li a.folder').click(function(){
		var loadUrl = $(this).attr('path');
		var loadUrl = "/admin/files/?path=" + $(this).attr('path') + "&subdomain=" + $(this).attr('subdomain')
		$('ul#file_list').load(loadUrl, function(){
			addListeners();
		});
		
	});
}