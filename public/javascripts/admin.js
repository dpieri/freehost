$(document).ready(function() {
	fixHeights();
	addListeners();
});

function addListeners(){
	$('li a.folder').click(function(){
		var loadUrl = $(this).attr('path');
		$('ul#file_list').load(loadUrl, function(){
			fixHeights();
		});
		
	});
}
function fixHeights(){
	var leftbox_height=$('#leftbox').height();
	var leftbox1_height=$('#leftbox1').height();
	if(leftbox_height>leftbox1_height){
		$('#leftbox1').height( $('#leftbox').height() );
	}else{
		$('#leftbox').height( $('#leftbox1').height() );
	}
	$("#file_list li:last").addClass("last");
	addListeners();  //do this in case it is not an initial load
}