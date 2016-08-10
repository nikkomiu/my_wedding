$(function() {
  $('.parallax').parallax();
  $('.tooltipped').tooltip({delay: 50});
  $('.modal-trigger').leanModal();
  $('select').material_select();

  var transition_prop = 'background-color 2s ease'

  // If is on /albums/:id
  if (document.location.pathname.match(/\/albums\/\d/) != null) {
    // If the page was not reloaded
    if (performance.navigation.type == 0) {
      // Add background transition
      $('html').css('transition', transition_prop)
    }

    // Transition from white to black
    $('html').css('background-color', '#292929')
  }

  // If was on /albums/:id and not still on it
  //   and the page was not reloaded
  if (document.referrer.match(/\/albums\/\d/) != null &&
      document.location.pathname.match(/\/albums\/\d/) == null &&
      performance.navigation.type != 1) {
    // Set the background to black
    $('html').css('background-color', '#292929');

    // Transition back to white
    setTimeout(function() {
      $('html').css('transition', transition_prop).css('background-color', '#FFF');
    },  1)
  }
})
