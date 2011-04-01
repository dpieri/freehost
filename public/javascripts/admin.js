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
function fixHeights(){
	// var leftbox_height=$('#leftbox').height();
	// var leftbox1_height=$('#leftbox1').height();
	// if(leftbox_height>leftbox1_height){
	// 	$('#leftbox1').height( $('#leftbox').height() );
	// }else{
	// 	$('#leftbox').height( $('#leftbox1').height() );
	// }
	// $("#file_list li:last").addClass("last");
	//addListeners();  //do this in case it is not an initial load
	// fixHeights();
}

function setHeights(){
	// $('#leftbox').css('height', '100%');
}