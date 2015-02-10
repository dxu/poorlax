$(document).ready ->
  $('#debug-check').click (evt) ->
    console.log this, this.checked
    if @checked
      $('.parallax-group').addClass 'debug'
    else
      $('.parallax-group').removeClass 'debug'



  console.log 'hello world'
