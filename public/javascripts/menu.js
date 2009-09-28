function mainmenu(){
    $(" #nav ul ").css({display: "none"}); // Opera Fix
	$(" #nav li").hover(function(){
		$(this).find('ul:first').css({visibility: "visible",display: "none"}).slideDown();
	},function(){
		$(this).find('ul:first').fadeOut(400);
	});
}
function scrollOnLink(){
	$('a').click(function(){
	$('html, body').animate({ 
		scrollTop: $($(this).attr("href"))
	  	.offset().top }, 1000);
	   return false;
	 });
}

function loadWidget(){
	$('#boxA').load('../../widgets/weather/weather.php');
}

function showmenu(){
    $(" #nav li").hover(function(){
    $(this).find('ul:first').css({visibility:"visible", display:"none"}).slideDown(400);
}, function(){
    $(this).find('ul:first').css({visibility:"hidden"});
});
}

$(document).ready(function(){					
	//mainmenu();
        showmenu();
	scrollOnLink();
	//loadWidget();
});