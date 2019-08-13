window.$crisp=[];window.CRISP_WEBSITE_ID="ce76b843-5726-4aa4-a059-c5a714da6626";(function(){d=document;s=d.createElement("script");s.src="https://client.crisp.chat/l.js";s.async=1;d.getElementsByTagName("head")[0].appendChild(s);})();

if (gon.user !== null) {
  $crisp.push(["set", "user:email", [gon.user.email]])
  $crisp.push(["set", "user:nickname", [gon.user.name]])
  $crisp.push(["set", "user:avatar", [gon.user.avatar]])
}
