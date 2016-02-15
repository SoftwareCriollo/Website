$(document).ready(function(){
  $("#form-contact").submit(function(event){
    event.preventDefault();

    var $form = $(this),
      data_params = decodeURIComponent($form.serialize()),
      url = $form.attr( "action" );

    $.post( url, data_params, function() {
      console.log("Success");
      $('section#getintouch .row-getintouch-contact').find('.getintouch-container-contact').addClass('animated fadeOutRight').delay(1500).hide(0);

      $('section#getintouch .row-getintouch-contact').find('.getintouch-container-thanks').addClass('animated fadeInLeft').delay(1500).show(0);
    }).fail( function() {
      console.log("Error");
    });

  });
});