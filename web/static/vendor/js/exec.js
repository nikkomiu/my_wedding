$(function() {
  $('.parallax').parallax();
  $('.tooltipped').tooltip({delay: 50});
  $('.modal-trigger').modal();
  $('select').material_select();

  albumBackground()
})

function albumBackground() {
  var transition_prop = 'background-color 2.3s ease'
  var path_regex = /\/albums\/\d+\/?$/

  // If is on /albums/:id
  if (document.location.pathname.match(path_regex) != null) {
    // If the page was not reloaded and there is a referrer
    if (performance.navigation.type == 0 &&
        document.referrer.match(path_regex) == null &&
        document.referrer != "") {
      // Add background transition
      $('html').css('transition', transition_prop)
    }

    // Transition from white to black
    $('html').css('background-color', '#292929')
  }

  // If was on /albums/:id, we left the page
  //   and this new page page was not reloaded
  if (document.referrer.match(path_regex) != null &&
      document.location.pathname.match(path_regex) == null &&
      performance.navigation.type != 1) {
    // Set the background to black
    $('html').css('background-color', '#292929');

    // Transition back to white
    setTimeout(function() {
      $('html').css('transition', transition_prop).css('background-color', '#FFF');
    },  1)
  }
}
