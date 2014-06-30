//= require "_tire"
//= require "_moment"

tire.ready(function(){
  start = moment('2005-12-05 09:00', 'YYYY-MM-DD HH:mm');
  now = moment();
  from = now.from(start, true)
  tire('.content-intro-period').html(from);
});
