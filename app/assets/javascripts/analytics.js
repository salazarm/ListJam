window.onload = function(){
  window.startTime = new Date();
};
window.onbeforeunload = function() {
  var endTime = new Date()
  var total_time = endTime.UTC()-window.startTime.UTC();
  var xhr = new XMLHttpRequest();
  xhr.open('POST', 'http://serene-brook-6278.herokuapp.com/', true);
  var params = "url_string="+location.origin+"&path_string="+location.location+"&total_time="+total_time;
  xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
  xhr.send(params);
};