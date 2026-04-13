document.write('<iframe id="aura_reviews" src="https://altitude.aurasalonware.com/reviews_embed.php" style="width:100%;height:600px;border:0;" frameborder="0"></iframe>');

var aura_eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
var aura_eventer = window[aura_eventMethod];
var aura_messageEvent = aura_eventMethod == "attachEvent" ? "onmessage" : "message";

aura_eventer(aura_messageEvent,function(e) {
	if(e.data && e.data.action && e.data.action=='aura_resize'){
		if(e.data.height && e.data.height>0){
			document.getElementById("aura_reviews").style.height = e.data.height+'px';
		}
	}
},false);

