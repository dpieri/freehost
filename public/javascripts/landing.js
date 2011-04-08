$(document).ready(function() {
	$('a.video').click(function(){
			$("#video").lightbox_me({
				centered: true,
				onClose: function(){
					$("#video").replaceWith("<iframe src='http://player.vimeo.com/video/22006055?title=0&amp;byline=0&amp;portrait=0&amp;color=ffffff' width='600' height='375' frameborder='0' id='video' style='display:none;'></iframe>");
				}
			});
			return false;
		});
});